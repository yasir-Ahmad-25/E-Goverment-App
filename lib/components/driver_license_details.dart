import 'package:flutter/material.dart';

class DriverLicenseDetails extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController issueDateController;
  final TextEditingController ExpireDateController;
  final TextEditingController expiryDateController;
  final TextEditingController fullNameController;
  final TextEditingController birthDateController;
  final TextEditingController genderController;
  final TextEditingController maritalStatusController;
  const DriverLicenseDetails({
    super.key,
    required this.cardNumberController,
    required this.issueDateController,
    required this.expiryDateController,
    required this.fullNameController,
    required this.birthDateController,
    required this.genderController,
    required this.maritalStatusController,
    required this.ExpireDateController,
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
        const SizedBox(height: 16),
        _buildTextField(
          controller: expiryDateController,
          icon: Icons.calendar_month,
          label: 'Date of Expiry',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: fullNameController,
          icon: Icons.person,
          label: 'Full Name',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: birthDateController,
          icon: Icons.cake,
          label: 'Birthdate',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: genderController,
          icon: Icons.people,
          label: 'Gender',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: maritalStatusController,
          icon: Icons.people_alt,
          label: 'Marital Status',
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
