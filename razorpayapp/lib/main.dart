import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Razorpay Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PaymentPage(),
    );
  }
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Razorpay razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Payment Successful: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed: ${response.message}");
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    return Scaffold(
      appBar: AppBar(
        title: Text("Razorpay Payment Gateway"),
      ),
      body: Center(
        child: OutlinedButton(
          onPressed: () {
            var options = {
              'key': 'rzp_test_QEwgoqd4Ud9o4A',
              'amount': 100, // in paise = ₹1
              'name': 'SEMO GAMING PVT LTD',
              'description': 'Subscription',
              'prefill': {
                'contact': '9205709689',
                'email': 'test@razorpay.com',
              },
            };

            try {
              razorpay.open(options);
            } catch (e) {
              debugPrint('Error: $e');
            }
          },
          child: Text("PAY ₹1"),
        ),
      ),
    );
  }
}
