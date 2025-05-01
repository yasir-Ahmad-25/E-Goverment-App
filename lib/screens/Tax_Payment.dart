import 'package:e_govermenet/screens/taxes_screen.dart';
import 'package:flutter/material.dart';

class TaxPayment extends StatefulWidget {
  final Tax tax;
  const TaxPayment({super.key, required this.tax});

  @override
  State<TaxPayment> createState() => _TaxPaymentState();
}

class _TaxPaymentState extends State<TaxPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tax Payment")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.tax.categoryId == 1) ...[Text("This is Vehicle Tax")],

              if (widget.tax.categoryId == 2) ...[Text("This is Business Tax")],

              if (widget.tax.categoryId == 3) ...[Text("This is House Tax")],

              if (widget.tax.categoryId == 4) ...[Text("This is Import Duty")],
            ],
          ),
        ),
      ),
    );
  }
}


