# Stripe rules
-keep class com.stripe.android.** { *; }
-keep class com.reactnativestripesdk.** { *; }
-keep class com.stripe.android.pushProvisioning.** { *; }
-keep class com.reactnativestripesdk.pushprovisioning.** { *; }
-keep class com.stripe.android.model.** { *; }
-dontwarn com.stripe.android.**
-dontwarn com.reactnativestripesdk.**
