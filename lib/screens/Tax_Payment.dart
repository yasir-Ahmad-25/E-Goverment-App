import 'dart:convert';
import 'package:e_govermenet/components/tax_screens/driver_license_details_TAX.dart';
import 'package:e_govermenet/components/tax_screens/driver_license_id_strcuture_TAX.dart';
import 'package:e_govermenet/screens/payment_success_page.dart';
import 'package:e_govermenet/screens/taxes_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaxPayment extends StatefulWidget {
  final Tax tax;
  const TaxPayment({super.key, required this.tax});

  @override
  State<TaxPayment> createState() => _TaxPaymentState();
}

class _TaxPaymentState extends State<TaxPayment> {
  String Driver_citizen_image_path = "";
  bool doesitHaveCar = false;
  bool isPaymentTime = false;

  String? taxDueDate; // From backend
  int daysUntilDue = 0;

  String taxAmount = "";

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
  String TaxPaymentTime_based_on_car = "0";
  @override
  void initState() {
    super.initState();
    _loadDriverLicenseData();
    _loadPaymentMethods();
  }

  Future<void> _loadDriverLicenseData() async {
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');

    try {
      var response = await http.get(
        Uri.parse('http://192.168.100.10/egov_back/driver_tax/$citizenId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' &&
            data['tax_data'] != null &&
            data['tax_data'].isNotEmpty) {
          final driverLicenseData = data['tax_data'][0];

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
            taxAmount = driverLicenseData['amount'];
            TaxPaymentTime_based_on_car = driverLicenseData['PaymentTimeToAdd'];

            if (driverLicenseData['Tax_Date'] != null) {
              taxDueDate = driverLicenseData['Tax_Date'];

              final DateTime taxDate = DateTime.parse(taxDueDate!);
              final DateTime now = DateTime.now();
              final int diffDays = taxDate.difference(now).inDays;

              setState(() {
                isPaymentTime =
                    taxDate.year == now.year &&
                    taxDate.month == now.month &&
                    taxDate.day == now.day &&
                    driverLicenseData['Tax_Status'] == 'unpaid';
                daysUntilDue = diffDays;
              });
            }

            setState(() {
              doesitHaveCar = true;
            });
          } else {
            setState(() {
              doesitHaveCar = false;
            });
          }
        } else {
          print("No Driver License data found.");
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

  Future<void> saveTax(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    // Step 1: Get current date
    final now = DateTime.now();

    // Step 2: Parse the tax payment timing (e.g., '3' or '6' months)
    final int monthsToAdd = int.tryParse(TaxPaymentTime_based_on_car) ?? 0;

    // Step 3: Add the months to current date to get due date
    final futureDate = DateTime(now.year, now.month + monthsToAdd, now.day);
    final String formattedDueDate = DateFormat('yyyy-MM-dd').format(futureDate);

    final url = Uri.parse('http://192.168.100.10/egov_back/saveTaxPayment');
    final body = {
      'user_id': userId.toString(),
      'category_id': widget.tax.categoryId.toString(),
      'amount': taxAmount,
      'due_date': formattedDueDate,
    };

    try {
      final response = await http.post(url, body: body);
      final data = jsonDecode(response.body);

      print(response.body);
      if (data['status'] == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PaymentSuccessPage()),
        );
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  bool isDriverPlateNumberValid(String? id) {
    return id != null && id != '0' && id.trim().isNotEmpty;
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
                doesitHaveCar
                    ? Column(
                      children: [
                        if (isPaymentTime) ...[
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: DriverLicenseIDStructureTax(
                              Driver_citizen_image_path:
                                  Driver_citizen_image_path,
                              plateNumber: _plateNumberController.text,
                              Fullname: _fullNameController.text,
                              Gender: _genderController.text,
                              DOB: _birthDateController.text,
                              issued_At:
                                  _DriverLicense_issueDateController.text,
                              Expire_At:
                                  _DriverLicense_expiryDateController.text,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: DriverLicenseDetailsTax(
                              cardNumberController: _plateNumberController,
                              issueDateController:
                                  _DriverLicense_issueDateController,
                              expiryDateController:
                                  _DriverLicense_expiryDateController,
                              fullNameController: _fullNameController,
                              birthDateController: _birthDateController,
                              genderController: _genderController,
                              maritalStatusController: _maritalStatusController,
                              ExpireDateController:
                                  _DriverLicense_expiryDateController,
                              paymentMethods: _paymentMethods,
                              Taxamount: taxAmount,
                              callbackMethod: () => saveTax(context),
                            ),
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              color: Colors.orange[50],
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Your tax payment is not due yet.\n"
                                        "You have $daysUntilDue day(s) left until your payment date: $taxDueDate.",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          color: Colors.orange[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    )
                    : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            color: Colors.red[50],
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "You don’t have a registered vehicle or a valid driver’s license on file. Please register your vehicle to access tax payment.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.red[800]),
                                    ),
                                  ),
                                ],
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
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  'driver_License_form',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text(
                                "Request Driver License",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              ],
              if (widget.tax.categoryId == 2) Text("This is Business Tax"),
              if (widget.tax.categoryId == 3) Text("This is House Tax"),
              if (widget.tax.categoryId == 4) Text("This is Import Duty"),
            ],
          ),
        ),
      ),
    );
  }
}
