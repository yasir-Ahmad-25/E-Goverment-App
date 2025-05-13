import 'package:e_govermenet/components/common/app_text_field.dart';
import 'package:e_govermenet/components/models/service_specific_data.dart';
import 'package:flutter/material.dart';

class NationalIdDetailsView extends StatefulWidget {
  final NationalIdData data;

  const NationalIdDetailsView({super.key, required this.data});

  @override
  State<NationalIdDetailsView> createState() => _NationalIdDetailsViewState();
}

class _NationalIdDetailsViewState extends State<NationalIdDetailsView> {
  late TextEditingController _cardNumberController;
  late TextEditingController _issueDateController;
  late TextEditingController _expiryDateController;
  late TextEditingController _fullNameController;
  late TextEditingController _birthDateController;
  late TextEditingController _genderController;
  late TextEditingController _maritalStatusController;

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController(text: widget.data.cardNumber);
    _issueDateController = TextEditingController(text: widget.data.issueDate);
    _expiryDateController = TextEditingController(text: widget.data.expiryDate);
    _fullNameController = TextEditingController(text: widget.data.fullName);
    _birthDateController = TextEditingController(text: widget.data.birthDate);
    _genderController = TextEditingController(text: widget.data.gender);
    _maritalStatusController = TextEditingController(text: widget.data.maritalStatus);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    _fullNameController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    _maritalStatusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Card Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (widget.data.isExpired)
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text("Renew"),
                  onPressed: () {
                    // TODO: Implement renewal navigation/logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Renewal action TBD"))
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                )
            ],
          ),
          const Divider(),
          AppTextField(controller: _cardNumberController, label: 'Card Number', icon: Icons.credit_card),
          const SizedBox(height: 16),
          AppTextField(controller: _issueDateController, label: 'Date of Issue', icon: Icons.calendar_today),
          const SizedBox(height: 16),
          AppTextField(controller: _expiryDateController, label: 'Date of Expiry', icon: Icons.calendar_month),
          const SizedBox(height: 16),
          AppTextField(controller: _fullNameController, label: 'Full Name', icon: Icons.person),
          const SizedBox(height: 16),
          AppTextField(controller: _birthDateController, label: 'Birthdate', icon: Icons.cake),
          const SizedBox(height: 16),
          AppTextField(controller: _genderController, label: 'Gender', icon: Icons.people),
          const SizedBox(height: 16),
          AppTextField(controller: _maritalStatusController, label: 'Marital Status', icon: Icons.family_restroom),
        ],
      ),
    );
  }
}