// functions/index.js
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const Stripe = require("stripe");
const express = require("express");
const bodyParser = require("body-parser");
const axios = require("axios");

admin.initializeApp();
const db = admin.firestore();

// Config vars (set via `firebase functions:config:set`)
const stripeSecret = functions.config().stripe.secret; // sk_test_xxx
const stripeWebhookSecret = functions.config().stripe.webhook_secret; // from Stripe dashboard
const stripeCurrency = functions.config().stripe.currency || 'usd';
const stripe = Stripe(stripeSecret);

/**
 * Callable: createPaymentIntent
 * data: { amountCents, currency(optional), reservationId, description }
 * Authenticated users only.
 */
exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Usuario no autenticado');
  }

  const userId = context.auth.uid;
  const reservationId = data.reservationId;
  const amountCents = Number(data.amountCents);
  const currency = data.currency || stripeCurrency;
  const description = data.description || `Reserva ${reservationId}`;

  if (!reservationId || !amountCents || amountCents <= 0) {
    throw new functions.https.HttpsError('invalid-argument', 'Argumentos inválidos');
  }

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amountCents,
      currency,
      metadata: { userId, reservationId },
      description,
    });

    const paymentDoc = {
      paymentIntentId: paymentIntent.id,
      reservationId,
      userId,
      amount: amountCents,
      currency,
      status: paymentIntent.status,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    };
    await db.collection('payments').doc(paymentIntent.id).set(paymentDoc);

    return { clientSecret: paymentIntent.client_secret, paymentIntentId: paymentIntent.id };
  } catch (err) {
    console.error("createPaymentIntent error:", err);
    throw new functions.https.HttpsError('internal', 'No se pudo crear PaymentIntent');
  }
});

/**
 * Webhook endpoint to receive Stripe events (payment_intent.succeeded).
 * This must be an HTTPS function (Express) with raw body parsing.
 */
const app = express();
// Need raw body for signature verification
app.use(bodyParser.raw({ type: 'application/json' }));

app.post('/stripeWebhook', async (req, res) => {
  const sig = req.headers['stripe-signature'];
  const buf = req.body;
  let event;

  try {
    event = stripe.webhooks.constructEvent(buf, sig, stripeWebhookSecret);
  } catch (err) {
    console.error('Webhook signature verification failed.', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle relevant events
  if (event.type === 'payment_intent.succeeded') {
    const pi = event.data.object;
    const paymentIntentId = pi.id;
    const metadata = pi.metadata || {};
    const reservationId = metadata.reservationId;
    const userId = metadata.userId;

    try {
      // Update payment doc
      await db.collection('payments').doc(paymentIntentId).set({
        paymentIntentId,
        reservationId,
        userId,
        amount: pi.amount,
        currency: pi.currency,
        status: pi.status,
        stripeEvent: event.id,
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      }, { merge: true });

      // Update reservation status
      if (reservationId) {
        await db.collection('reservas').doc(reservationId).update({
          status: 'paid',
          paidAt: admin.firestore.FieldValue.serverTimestamp(),
          paymentIntentId
        });
      }

      console.log(`PaymentIntent ${paymentIntentId} succeeded; reservation ${reservationId} marked paid.`);
    } catch (err) {
      console.error('Error updating Firestore on webhook:', err);
      return res.status(500).send();
    }
  }

  // respond 200 to Stripe
  res.json({ received: true });
});

exports.stripeWebhook = functions.https.onRequest(app);

/**
 * Optional callable: markPaymentComplete (backup)
 * Validates payment intent with Stripe and updates Firestore.
 * This can be used by client but prefer webhook as primary source of truth.
 * data: { paymentIntentId }
 */
exports.markPaymentComplete = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'No auth');
  const paymentIntentId = data.paymentIntentId;
  if (!paymentIntentId) throw new functions.https.HttpsError('invalid-argument', 'paymentIntentId missing');

  try {
    const pi = await stripe.paymentIntents.retrieve(paymentIntentId);
    if (pi.status !== 'succeeded') {
      throw new functions.https.HttpsError('failed-precondition', 'Pago no completado');
    }

    const reservationId = pi.metadata?.reservationId;
    await db.collection('payments').doc(paymentIntentId).set({
      status: pi.status,
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    }, { merge: true });

    if (reservationId) {
      await db.collection('reservas').doc(reservationId).update({
        status: 'paid',
        paidAt: admin.firestore.FieldValue.serverTimestamp(),
        paymentIntentId
      });
    }
    return { ok: true };
  } catch (err) {
    console.error('markPaymentComplete error:', err);
    throw new functions.https.HttpsError('internal', 'Error marcando pago');
  }
});

/**
 * PAYPAL (opcional): Crear orden PayPal y devolver URL de aprobación
 * Requires PAYPAL_CLIENT_ID and PAYPAL_SECRET set in functions config.
 */
const PAYPAL_CLIENT_ID = functions.config().paypal?.client_id;
const PAYPAL_SECRET = functions.config().paypal?.secret;
const PAYPAL_BASE = functions.config().paypal?.sandbox == "true" ? 'https://api-m.sandbox.paypal.com' : 'https://api-m.paypal.com';

exports.createPayPalOrder = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'No auth');
  const reservationId = data.reservationId;
  const amount = data.amount; // string like "70.30"
  if (!reservationId || !amount) throw new functions.https.HttpsError('invalid-argument', 'Missing args');

  // Get access token
  try {
    const tokenRes = await axios({
      url: `${PAYPAL_BASE}/v1/oauth2/token`,
      method: 'post',
      auth: { username: PAYPAL_CLIENT_ID, password: PAYPAL_SECRET },
      params: { grant_type: 'client_credentials' }
    });
    const accessToken = tokenRes.data.access_token;

    // Create order
    const orderRes = await axios({
      url: `${PAYPAL_BASE}/v2/checkout/orders`,
      method: 'post',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${accessToken}`
      },
      data: {
        intent: 'CAPTURE',
        purchase_units: [{ amount: { currency_code: 'USD', value: amount }, description: `Reserva ${reservationId}` }],
        application_context: {
          return_url: 'https://your-app.com/paypal/return', // or any deep link you handle
          cancel_url: 'https://your-app.com/paypal/cancel'
        }
      }
    });

    const order = orderRes.data;
    // save minimal payment doc
    await db.collection('payments').doc(order.id).set({
      paymentMethod: 'paypal',
      orderId: order.id,
      reservationId,
      userId: context.auth.uid,
      status: order.status,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    // find approval link
    const approveLink = order.links.find(l => l.rel === 'approve')?.href;
    return { approveLink, orderId: order.id };
  } catch (err) {
    console.error('PayPal create order error', err);
    throw new functions.https.HttpsError('internal', 'Error creando orden PayPal');
  }
});

/**
 * capturePayPalOrder - callable to capture the payment after user approves
 * data: { orderId }
 */
exports.capturePayPalOrder = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'No auth');
  const orderId = data.orderId;
  if (!orderId) throw new functions.https.HttpsError('invalid-argument', 'orderId missing');

  try {
    // get token
    const tokenRes = await axios({
      url: `${PAYPAL_BASE}/v1/oauth2/token`,
      method: 'post',
      auth: { username: PAYPAL_CLIENT_ID, password: PAYPAL_SECRET },
      params: { grant_type: 'client_credentials' }
    });
    const accessToken = tokenRes.data.access_token;

    const capRes = await axios({
      url: `${PAYPAL_BASE}/v2/checkout/orders/${orderId}/capture`,
      method: 'post',
      headers: { Authorization: `Bearer ${accessToken}`, 'Content-Type': 'application/json' }
    });

    const capture = capRes.data;
    // update payment doc and reservation
    await db.collection('payments').doc(orderId).set({
      status: 'COMPLETED',
      capture,
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    }, { merge: true });

    const reservationId = (await db.collection('payments').doc(orderId).get()).data()?.reservationId;
    if (reservationId) {
      await db.collection('reservas').doc(reservationId).update({ status: 'paid', paidAt: admin.firestore.FieldValue.serverTimestamp() });
    }
    return { ok: true, capture };
  } catch (err) {
    console.error('capturePayPalOrder error', err.response?.data || err);
    throw new functions.https.HttpsError('internal', 'Error capturando PayPal');
  }
});
