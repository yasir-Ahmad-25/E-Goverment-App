import 'dart:convert';
import 'dart:math';
import 'package:e_govermenet/components/services/api_constants.dart';
import 'package:e_govermenet/components/tax_screens/business_tax_form.dart';
import 'package:e_govermenet/components/tax_screens/driver_license_details_TAX.dart';
import 'package:e_govermenet/components/tax_screens/driver_license_id_strcuture_TAX.dart';
import 'package:e_govermenet/components/tax_screens/house_tax_form.dart';
import 'package:e_govermenet/screens/payment_success_page.dart';
import 'package:e_govermenet/screens/taxes_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool doesitHaveBusiness = false;
  bool isPaymentTime = false;
  bool isBusinessPayTime = false;

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

  //============================  Business Tax:  =========================
  final _formKey = GlobalKey<FormState>();

  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessTypeController = TextEditingController();
  TextEditingController annualIncomeController = TextEditingController();

  // ========================== House Tax ===============================
  final _HouseformKey = GlobalKey<FormState>();

  TextEditingController houseNumberController = TextEditingController();
  String? selectedHouseType;
  final double _housetaxAmount = 0.0;

  final Map<String, double> taxRates = {
    "Apartment": 200.0,
    "Villa": 500.0,
    "Townhouse": 350.0,
    "Cottage": 150.0,
  };

  void _updateTaxAmount(String? type) {
    setState(() {
      selectedHouseType = type;
      taxAmount = (taxRates[type] ?? 0.0) as String;
    });
  }

  List<Map<String, dynamic>> _paymentMethods = [];
  String TaxPaymentTime_based_on_car = "0";
  String business_TaxPaymentTime = "0";
  @override
  void initState() {
    super.initState();
    _loadDriverLicenseData();
    _loadBusinessData();
    _loadPaymentMethods();
  }

  Future<void> _loadDriverLicenseData() async {
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');

    try {
      var response = await http.get(
        // Uri.parse('http://192.168.202.39/Som-Gov/driver_tax/$citizenId'),
        Uri.parse(ApiConstants.fetch_driver_tax(citizenId!)),
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
                    taxDate.year <= now.year &&
                    taxDate.month <= now.month &&
                    taxDate.day <= now.day &&
                    driverLicenseData['Tax_Status'] == 'Unpaid';
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
    } catch (e, stackTrace) {
      print('❌ Error: $e');
      print('StackTrace: $stackTrace');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> _loadBusinessData() async {
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');

    try {
      var response = await http.get(
        // Uri.parse('http://192.168.202.39/Som-Gov/business_tax/$citizenId'),
        Uri.parse(ApiConstants.fetch_businessTax(citizenId!)),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' &&
            data['tax_data'] != null &&
            data['tax_data'].isNotEmpty) {
          final businessData = data['tax_data'][0];


          if (isBusinessStatusValid(businessData['business_status'])) {
            businessNameController.text = businessData['business_name'];
            businessTypeController.text = businessData['business_type'];
            annualIncomeController.text = businessData['amount'];
            business_TaxPaymentTime = businessData['due_date'];

            if (businessData['due_date'] != null) {
              taxDueDate = businessData['due_date'];

              final DateTime taxDate = DateTime.parse(taxDueDate!);
              final DateTime now = DateTime.now();
              final int diffDays = taxDate.difference(now).inDays;

              setState(() {
                isBusinessPayTime =
                    taxDate.year <= now.year &&
                    taxDate.month <= now.month &&
                    taxDate.day <= now.day &&
                    businessData['status'] == 'Unpaid';
                daysUntilDue = diffDays;
              });
            }

            setState(() {
              doesitHaveBusiness = true;
            });
          } else {
            setState(() {
              doesitHaveBusiness = false;
            });
          }
        } else {
          print("No Business data found.");
        }
      } else {
        throw Exception("Failed to load Business data.");
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
        // Uri.parse('http://192.168.202.39/egov_back/payment_methods/'),
        Uri.parse(ApiConstants.fetchPaymentMethods()),
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
    final citizenId = prefs.getInt('user_id');

    // Step 1: Get current date
    final now = DateTime.now();

    // Step 2: Parse the tax payment timing (e.g., '3' or '6' months)
    final int monthsToAdd = int.tryParse(TaxPaymentTime_based_on_car) ?? 0;

    // Step 3: Add the months to current date to get due date
    final futureDate = DateTime(now.year, now.month + monthsToAdd, now.day);
    final String formattedDueDate = DateFormat('yyyy-MM-dd').format(futureDate);

    // final url = Uri.parse('http://192.168.202.39/Som-Gov/saveTaxPayment');
    final url = Uri.parse(ApiConstants.saveTaxPayment());
    final body = {
      'citizen_id': citizenId.toString(),
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

  bool isBusinessStatusValid(String? status) {
    return status != null && status != 'Requested' && status.trim().isNotEmpty;
  }

  Future<void> saveBusinessTax(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');

    // Step 1: Get current date
    final now = DateTime.now();
    final nextYearDate = DateTime(now.year + 1, now.month, now.day);
    final formattedDueDate = DateFormat('yyyy-MM-dd').format(nextYearDate);

    final url = Uri.parse(ApiConstants.saveBusinessTaxPayment());
    final body = {
      'citizen_id': citizenId.toString(),
      'category_id': '3',
      'amount': annualIncomeController.text,
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

  void saveHouseTax(BuildContext context) async {
    print("button clicked");
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');

    // Step 1: Get current date
    final now = DateTime.now();

    // Step 2: Parse the tax payment timing (e.g., '3' or '6' months)
    final int monthsToAdd = int.tryParse(TaxPaymentTime_based_on_car) ?? 0;

    // Step 3: Add the months to current date to get due date
    final futureDate = DateTime(now.year, now.month + monthsToAdd, now.day);
    final String formattedDueDate = DateFormat('yyyy-MM-dd').format(futureDate);

    final url = Uri.parse(ApiConstants.saveHouseTaxPayment());
    final body = {
      'citizen_id': citizenId.toString(),
      'category_id': '100',
      'amount': taxAmount.toString(),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tax Payment"),
        actions: [
          IconButton(
            onPressed: () async {
              await _loadDriverLicenseData();
            },
            icon: Icon(FontAwesomeIcons.arrowsRotate),
          ),
        ],
      ),
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
              if (widget.tax.categoryId == 2) ...[
                doesitHaveBusiness
                    ? Column(
                      children: [

                        if(isBusinessPayTime) ...[
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Business Tax Details",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),

                                TextFormField(
                                  controller: businessNameController,
                                  decoration: InputDecoration(
                                    labelText: "Business Name",
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.business),
                                  ),
                                  validator:
                                      (value) =>
                                  value!.isEmpty
                                      ? "Please enter business name"
                                      : null,
                                ),
                                SizedBox(height: 15),

                                TextFormField(
                                  controller: businessTypeController,
                                  decoration: InputDecoration(
                                    labelText: "Business Type",
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.confirmation_number),
                                  ),
                                  validator:
                                      (value) =>
                                  value!.isEmpty
                                      ? "Please enter Business Type"
                                      : null,
                                ),
                                SizedBox(height: 15),

                                TextFormField(
                                  controller: annualIncomeController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Annual Income (\$)",
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.attach_money),
                                  ),
                                  // validator:
                                  //     (value) =>
                                  //         value!.isEmpty ? "Please enter income" : null,
                                  // onChanged: (value) {
                                  //   setState(() {
                                  //     double income = double.tryParse(value) ?? 0;
                                  //     // 💡 Example logic: 10% of income as tax
                                  //     taxAmount = (income * 0.10).toStringAsFixed(2);
                                  //   });
                                  // },
                                ),
                                SizedBox(height: 20),

                                if (annualIncomeController.text.isNotEmpty)
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.green),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.receipt_long, color: Colors.green),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            "Estimated Tax to Pay: \$${annualIncomeController.text}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.green[700],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 25),

                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
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
                                                paymentMethods: _paymentMethods,
                                                callbackMethod: () => saveBusinessTax(context),
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
                                ),
                              ],
                            ),
                          )
                        ]else ...[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              color: Colors.orange[50],
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      color: Colors.orange[800],
                                      size: 34,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "No Action Needed",
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: Colors.orange[900],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Your next tax payment is not due yet.",
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Colors.orange[800],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "You have $daysUntilDue day(s) left until your payment date:\n$taxDueDate.",
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Colors.orange[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          ,
                        ]
                      ],
                    )
                    :  Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        color: Colors.orange[50],
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.business_rounded,
                                color: Colors.orange,
                                size: 44,
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "No Business Registered",
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.orange[900],
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "You don’t have a registered business or a valid business license on file. Please register your business to access tax payment features and stay compliant.",
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.orange[800],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.info_outline, color: Colors.orange, size: 18),
                                        const SizedBox(width: 6),
                                        Text(
                                          "Business registration is required by law.",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.orange[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.assignment_add, size: 22),
                          label: const Text(
                            "Register My Business",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, 'business_form');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],

              if (widget.tax.categoryId == 3) ...[
                Form(
                  key: _HouseformKey,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      16.0,
                    ), // ✅ Clean margin from screen edge
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "House Tax Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),

                        TextFormField(
                          controller: houseNumberController,
                          decoration: InputDecoration(
                            labelText: "House Number",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.home),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? "Please enter house number"
                                      : null,
                        ),
                        SizedBox(height: 20),

                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: "House Type",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.apartment),
                          ),
                          value: selectedHouseType,
                          items:
                              taxRates.keys.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                          onChanged: (type) {
                            setState(() {
                              selectedHouseType = type;
                              taxAmount = (taxRates[type] ?? 0).toStringAsFixed(
                                2,
                              );
                            });
                          },
                          validator:
                              (value) =>
                                  value == null
                                      ? "Please select a house type"
                                      : null,
                        ),
                        SizedBox(height: 25),

                        if (taxAmount.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.receipt_long, color: Colors.orange),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Estimated Tax to Pay: \$$taxAmount",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.orange[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 25),

                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
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
                                        paymentMethods: _paymentMethods,
                                        callbackMethod: () => saveHouseTax(context),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              if (widget.tax.categoryId == 4) Text("This is Import Duty"),
            ],
          ),
        ),
      ),
    );
  }
}
