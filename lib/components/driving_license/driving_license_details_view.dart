// lib/components/driving_license/driving_license_details_view.dart
import 'package:e_govermenet/components/models/service_specific_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/app_text_field.dart';

class DrivingLicenseDetailsView extends StatefulWidget {
  final DriverLicenseData data;

  const DrivingLicenseDetailsView({super.key, required this.data});

  @override
  State<DrivingLicenseDetailsView> createState() => _DrivingLicenseDetailsViewState();
}

class _DrivingLicenseDetailsViewState extends State<DrivingLicenseDetailsView> {
  late TextEditingController _plateNumberController; // Or License Number
  late TextEditingController _issueDateController;
  late TextEditingController _expiryDateController;
  late TextEditingController _fullNameController;
  late TextEditingController _birthDateController;
  late TextEditingController _genderController;
  // Marital status was in your original, decide if it's relevant for driving license display
  // late TextEditingController _maritalStatusController;


  @override
  void initState() {
    super.initState();
    _plateNumberController = TextEditingController(text: widget.data.plateNumber);
    _issueDateController = TextEditingController(text: widget.data.issuedAt);
    _expiryDateController = TextEditingController(text: widget.data.expireAt);
    _fullNameController = TextEditingController(text: widget.data.fullName); // From NationalIdProfile
    _birthDateController = TextEditingController(text: widget.data.birthDate); // From NationalIdProfile
    _genderController = TextEditingController(text: widget.data.gender); // From NationalIdProfile
    // _maritalStatusController = TextEditingController(text: widget.data.maritalStatus);
  }

  @override
  void dispose() {
    _plateNumberController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    _fullNameController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    // _maritalStatusController.dispose();
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
              const Text("License Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
               if (widget.data.isExpired)
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text("Renew License"),
                  onPressed: () {
                    // TODO: Navigate to license renewal form
                    Navigator.pushNamed(context, 'driver_license_renewal_form');
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Navigate to License Renewal TBD"))
                    );
                  },
                   style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                )
            ],
          ),
          const Divider(),
          AppTextField(controller: _plateNumberController, label: 'License Number (Plate No.)', icon: FontAwesomeIcons.idCard),
          const SizedBox(height: 16),
          AppTextField(controller: _issueDateController, label: 'Date of Issue', icon: Icons.calendar_today),
          const SizedBox(height: 16),
          AppTextField(controller: _expiryDateController, label: 'Date of Expiry', icon: Icons.calendar_month),
          const SizedBox(height: 16),
          AppTextField(controller: _fullNameController, label: 'Full Name', icon: Icons.person),
          const SizedBox(height: 16),
          AppTextField(controller: _birthDateController, label: 'Birthdate', icon: Icons.cake),
          const SizedBox(height: 16),
          AppTextField(controller: _genderController, label: 'Gender', icon: FontAwesomeIcons.venusMars),
          // const SizedBox(height: 16),
          // AppTextField(controller: _maritalStatusController, label: 'Marital Status', icon: Icons.family_restroom),
        ],
      ),
    );
  }
}