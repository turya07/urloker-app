import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_tutorial/localization/location_search.dart';
import 'package:flutter_stripe_tutorial/main_activity.dart';

class AppConfig {
  static const String stripePublishableKey = 'pk_live_51PbxMUBwcWogP8JA1YhMcYc9tiSrLV04XsjkS5dEQZsKhdst7Y6KaVK8SmsvK4rVAXouklr8UTQl3YlYeqtNu98T00PVhgg5jk';
  static const String stripeSecretKey = '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';
  static const String apiBaseUrl = 'https://urlocker-api.onrender.com/api/v1';
}

class PaymentScreen extends StatefulWidget {

  const PaymentScreen({super.key, required this.amount, required bookingId,});
  final double amount;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final StripePaymentService _stripeService = StripePaymentService();
  bool isLoading = false;
  late double displayAmount;  // Add this variable

  @override
  void initState() {
    super.initState();
    displayAmount = widget.amount;  // Initialize the display amount
  }

  @override
  void didUpdateWidget(PaymentScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount) {
      setState(() {
        displayAmount = widget.amount;  // Update if the amount changes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Payment Details',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment Amount Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'A\$${displayAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'AUD',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Payment Info
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.credit_card,
                                color: Color(0xFF64748B),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment Method',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  'Credit/Debit Card',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Pay Now Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                      setState(() {
                        isLoading = true;
                      });
                      await _stripeService.initializePayment(
                        context,
                        displayAmount,
                      );
                      if (mounted) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Pay Securely Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Security Note
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.security,
                        size: 16,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Secure Payment via Stripe',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class StripePaymentService {
  final dio = Dio();

  Future<void> initializePayment(BuildContext context, double amount) async {
    try {
      // Convert amount to cents (multiply by 100)
      final amountInCents = (amount * 100).round();

      // Create Payment Intent
      final paymentIntent = await _createPaymentIntent(
        amountInCents,
        'aud', // Currency
      );

      if (!paymentIntent['success']) {
        _showError(context, paymentIntent['message']);
        return;
      }

      // Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['clientSecret'],
          merchantDisplayName: "Urlocker Pty Ltd",
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'AUD',
            testEnv: true,
          ),
        ),
      );

      // Present Payment Sheet and handle response
      try {
        await Stripe.instance.presentPaymentSheet();
        // Payment successful
        if (context.mounted) { // Check if context is still valid
          await _showSuccessDialog(context);
        }
      }on StripeException catch (e) {
        if (context.mounted) { // Check if context is still valid
          if (e.error.code == 'Canceled') {  // Changed this line
            _showError(context, 'Payment cancelled');
          } else {
            _showError(context, e.error.message ?? 'Payment failed');
          }
        }
        return;
      }

    } on StripeException catch (e) {
      if (context.mounted) {
        _showError(context, e.error.message ?? 'Payment failed');
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(int amount, String currency) async {
    try {
      final response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: {
          "amount": amount.toString(),
          "currency": currency,
          "payment_method_types[]": "card"
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer ${AppConfig.stripeSecretKey}",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );

      return {
        'success': true,
        'clientSecret': response.data["client_secret"]
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to create payment intent: ${e.toString()}',
      };
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 48,
              ),
              SizedBox(height: 16),
              Text('Your payment has been processed successfully!'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // You can add navigation or other actions here
                // For example, navigate to a confirmation page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentSuccessScreen(), // Create this screen
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// Create a success screen to navigate to after payment
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 24),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your payment has been processed\nand your booking is confirmed.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to home or booking list
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MainActivity(), // Replace with your home screen
                  ),
                      (route) => false,
                );
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}




