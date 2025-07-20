import 'package:e_govermenet/screens/payment_gatewate_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChargePage extends StatefulWidget {
  final String imageAsset;
  final List<Widget> instructions;
  final double amount;
  final Future<void> Function()? onPaymentSuccess;
  final List<Map<String, dynamic>> paymentMethods;

  const ChargePage({
    Key? key,
    required this.imageAsset,
    required this.instructions,
    required this.amount,
    this.onPaymentSuccess,
    required this.paymentMethods,
  }) : super(key: key);

  @override
  State<ChargePage> createState() => _ChargePageState();
}

class _ChargePageState extends State<ChargePage> {
  bool isPaying = false;
  String? paidMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Charge'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(widget.imageAsset, width: 180, height: 120),
            SizedBox(height: 24),
            ...widget.instructions,
            SizedBox(height: 28),
            if (isPaying)
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text("Processing payment...", style: TextStyle(fontSize: 15)),
                ],
              )
            else if (paidMethod != null)
              Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                  SizedBox(height: 10),
                  Text(
                    "Paid with $paidMethod!",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     if (widget.onPaymentSuccess != null) {
                  //       await widget.onPaymentSuccess!();
                  //       // Optionally, navigate or show another dialog here
                  //       Navigator.pop(context); // Go back to previous page
                  //     }
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.green,
                  //     foregroundColor: Colors.white,
                  //     minimumSize: Size(double.infinity, 48),
                  //   ),
                  //   child: Text("Continue"),
                  // ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => PaymentOptionsBottomSheet(
                        paymentMethods: widget.paymentMethods,
                        onPay: (method) async {
                          setState(() {
                            isPaying = true;
                          });

                          // 1. Simulate payment processing
                          await Future.delayed(Duration(seconds: 2)); // replace with real payment logic

                          // 2. Save to DB
                          await widget.onPaymentSuccess?.call();

                          setState(() {
                            isPaying = false;
                            paidMethod = method;
                          });

                          // 3. Show a short dialog or snackbar (optional)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Payment successful and request submitted!")),
                          );

                          // 4. Navigate to home (replace with your home page route)
                          Future.delayed(Duration(milliseconds: 600), () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          });
                        },

                      ),
                    );
                  },
                  child: Text("Pay \$${widget.amount.toStringAsFixed(2)}"),
                ),
              ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
// Benefit row widget
class BenefitRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Widget text;
  const BenefitRow({
    Key? key,
    required this.icon,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0, bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.13),
            radius: 19,
            child: Icon(icon, color: color, size: 22),
          ),
          SizedBox(width: 16),
          Expanded(child: text),
        ],
      ),
    );
  }
}

Future<bool> _showPaymentDialog(BuildContext context, double amount) async {
  return await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Demo Payment"),
      content: Text("Pretend you paid \$${amount.toStringAsFixed(2)}!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text("Confirm Payment"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("Cancel"),
        ),
      ],
    ),
  ) ?? false;
}




class PaymentOptionsBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> paymentMethods;
  final Future<void> Function(String paymentMethod)? onPay;

  const PaymentOptionsBottomSheet({
    Key? key,
    required this.paymentMethods,
    required this.onPay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Text(
            "Choose Payment Method",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...paymentMethods.map((method) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: method['icon'] != null
                    ? Image.asset(method['icon'], width: 32, height: 32)
                    : Icon(Icons.payment, color: Colors.redAccent),
                title: Text(method['payment']),
                onTap: () async {
                  Navigator.pop(context); // Close the modal
                  if (onPay != null) {
                    await onPay!(method['payment']);
                  }
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
