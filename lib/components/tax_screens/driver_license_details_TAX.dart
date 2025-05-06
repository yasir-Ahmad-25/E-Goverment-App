import 'package:e_govermenet/screens/payment_success_page.dart';
import 'package:flutter/material.dart';

class DriverLicenseDetailsTax extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController issueDateController;
  final TextEditingController ExpireDateController;
  final TextEditingController expiryDateController;
  final TextEditingController fullNameController;
  final TextEditingController birthDateController;
  final TextEditingController genderController;
  final TextEditingController maritalStatusController;
  final List<Map<String, dynamic>> paymentMethods;
  const DriverLicenseDetailsTax({
    super.key,
    required this.cardNumberController,
    required this.issueDateController,
    required this.expiryDateController,
    required this.fullNameController,
    required this.birthDateController,
    required this.genderController,
    required this.maritalStatusController,
    required this.ExpireDateController,
    required this.paymentMethods,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "License - Details",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Divider(),
        _buildTextField(
          controller: cardNumberController,
          icon: Icons.credit_card,
          label: 'Plate Number',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: issueDateController,
          icon: Icons.calendar_today,
          label: 'Date of Issue',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: ExpireDateController,
          icon: Icons.calendar_today,
          label: 'Date of Expire',
        ),
        SizedBox(height: 15),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              textAlign: TextAlign.right,
              "\$15",
              style: TextStyle(
                fontSize: 28,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        SizedBox(height: 15),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // onPressed: _submitForm,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder:
                      (context) => Container(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              8,
                            ), // Set your preferred radius here
                          ),
                        ),
                        child: PaymentOptionsBottomSheet(
                          paymentMethods: paymentMethods,
                        ),
                      ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.redAccent, // Background color (primary blue)
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 8px border radius
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ), // Optional: Adjust padding
              ),
              child: Text(
                "PAY TAX",
                style: TextStyle(fontSize: 16), // Optional: Adjust text size
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required IconData icon,
  required String label,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    readOnly: true, // Make fields non-editable (if needed)
  );
}

class PaymentOptionsBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> paymentMethods;
  const PaymentOptionsBottomSheet({super.key, required this.paymentMethods});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
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
          // Responsive height for list
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: ListView.builder(
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.payment, color: Colors.redAccent),
                    title: Text(method['payment']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => PaymentSuccessPage(
                                message:
                                    "Thank you! Your payment has been processed.",
                                buttonText: "Go Home",
                                onButtonPressed: () {
                                  Navigator.popUntil(
                                    context,
                                    (route) => route.isFirst,
                                  );
                                },
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
