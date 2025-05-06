import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const PaymentSuccessPage({
    super.key,
    this.message = "Your payment was successful!",
    this.buttonText = "Done",
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1,
              vertical: size.height * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: size.width * 0.3,
                ),
                SizedBox(height: 24),
                Text(
                  "Payment Successful",
                  style: TextStyle(
                    fontSize: size.width * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.1),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: onButtonPressed ?? () => Navigator.pop(context),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        color: Colors.white,
                      ),
                    ),
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
