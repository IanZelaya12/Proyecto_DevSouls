import 'package:flutter/material.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPayment = 0;

  final List<Map<String, dynamic>> _paymentMethods = [
    {"icon": Icons.credit_card, "label": "VISA ****2109"},
    {"icon": Icons.account_balance_wallet, "label": "PayPal ****2109"},
    {"icon": Icons.account_balance, "label": "MasterCard ****2109"},
    {"icon": Icons.apple, "label": "Apple Pay ****2109"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Order", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [Text("7,000"), Text("₹")],
            ),
            const SizedBox(height: 8),
            const Text("Shipping", style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [Text("30"), Text("₹")],
            ),
            const Divider(height: 32, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Total",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "7,030 ₹",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Payment",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _selectedPayment == index
                            ? Colors.green
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        _paymentMethods[index]["icon"],
                        color: Colors.blue,
                      ),
                      title: Text(_paymentMethods[index]["label"]),
                      onTap: () {
                        setState(() {
                          _selectedPayment = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentSuccessScreen(),
                  ),
                );
              },
              child: const Text("Continue", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
