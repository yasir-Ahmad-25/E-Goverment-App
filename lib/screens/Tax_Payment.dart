import 'dart:convert';

import 'package:e_govermenet/components/tax_screens/driver_license_details_TAX.dart';
import 'package:e_govermenet/components/tax_screens/driver_license_id_strcuture_TAX.dart';
import 'package:e_govermenet/screens/taxes_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaxPayment extends StatefulWidget {
  final Tax tax;
  const TaxPayment({super.key, required this.tax});

  @override
  State<TaxPayment> createState() => _TaxPaymentState();
}

class _TaxPaymentState extends State<TaxPayment> {
  String Driver_citizen_image_path = "";
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _DriverLicense_issueDateController =
      TextEditingController();
  final TextEditingController _DriverLicense_expiryDateController =
      TextEditingController();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _maritalStatusController =
      TextEditingController();
  List<Map<String, dynamic>> _paymentMethods = [];

  Future<void> _loadDriverLicenseData() async {
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');

    try {
      var response = await http.get(
        Uri.parse('http://192.168.100.10/egov_back/driver_license/$citizenId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' &&
            data['driver_License_Data'] != null &&
            data['driver_License_Data'].isNotEmpty) {
          final driverLicenseData = data['driver_License_Data'][0];

          // Check if the national_id_number is not "0" or empty
          if (isDriverPlateNumberValid(driverLicenseData['plate_number'])) {
            _plateNumberController.text = driverLicenseData['plate_number'];
            _DriverLicense_issueDateController.text =
                driverLicenseData['issued_At'];
            _DriverLicense_expiryDateController.text =
                driverLicenseData['Expire_At'];
            _fullNameController.text = driverLicenseData['fullname'];
            _birthDateController.text = driverLicenseData['birthdate'];
            _genderController.text = driverLicenseData['gender'];
            Driver_citizen_image_path = driverLicenseData['citizen_image'];

            // _driverLicense_requestStatus = driverLicenseData['license_status'];
            setState(() {
              // hasDriverLicense = true;
            });
          } else {
            // setState(() {
            //   // hasDriverLicense = false;
            // });
            print("Driver License not approved or invalid.");
          }
        } else {
          print("No Driver License data found.");
          // setState(() {
          //   // hasDriverLicense = false;
          // });
        }
      } else {
        throw Exception("Failed to load Driver License data.");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> _loadPaymentMethods() async {
    try {
      // Fetch services data
      final response = await http.get(
        Uri.parse('http://192.168.100.10/egov_back/payment_methods/'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _paymentMethods = List<Map<String, dynamic>>.from(
              data['payment_methods'],
            );
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
          "Failed To Fetch Payment Methods: ${response.statusCode}",
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  bool isDriverPlateNumberValid(String? id) {
    return id != null && id != '0' && id.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    _loadDriverLicenseData();
    _loadPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tax Payment")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.tax.categoryId == 1) ...[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DriverLicenseIDStructureTax(
                    Driver_citizen_image_path: Driver_citizen_image_path,
                    plateNumber: _plateNumberController.text,
                    Fullname: _fullNameController.text,
                    Gender: _genderController.text,
                    DOB: _birthDateController.text,
                    issued_At: _DriverLicense_issueDateController.text,
                    Expire_At: _DriverLicense_expiryDateController.text,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DriverLicenseDetailsTax(
                    cardNumberController: _plateNumberController,
                    issueDateController: _DriverLicense_issueDateController,
                    expiryDateController: _DriverLicense_expiryDateController,
                    fullNameController: _fullNameController,
                    birthDateController: _birthDateController,
                    genderController: _genderController,
                    maritalStatusController: _maritalStatusController,
                    ExpireDateController: _DriverLicense_expiryDateController,
                    paymentMethods: _paymentMethods,
                  ),
                ),
              ],

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
