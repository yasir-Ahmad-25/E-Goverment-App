import 'package:flutter/material.dart';

class PaymentGatewaysPage extends StatelessWidget {
  final double amount;

  const PaymentGatewaysPage({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose Payment Method')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.payment, color: Colors.teal),
            title: Text('WAAFI'),
            onTap: () async {
              // Implement payment integration here (API call, etc)
              // After successful payment:
              Navigator.pop(context, true);
            },
          ),
          // Add more payment methods here
        ],
      ),
    );
  }
}
