import 'dart:convert';
import 'dart:io';

import 'package:e_govermenet/components/document_uploader.dart';
import 'package:e_govermenet/components/input_fields.dart';
import 'package:e_govermenet/components/national_id_uploader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverLicenseForm extends StatefulWidget {
  const DriverLicenseForm({super.key});

  @override
  State<DriverLicenseForm> createState() => _DriverLicenseFormState();
}

class _DriverLicenseFormState extends State<DriverLicenseForm> {
  String? fullName;
  String? gender;
  String? phone;
  String? birthdate;

  File? _citizenImg;
  File? _document;
  File? _cid_document;
  File? _healthcare_document;

  DateTime? _dob;

  bool showOtherField = false;

  final TextEditingController _Fullname = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _car_Type = TextEditingController();
  final TextEditingController _plate_number = TextEditingController();
  final TextEditingController _vehicle_color = TextEditingController();

  final TextEditingController _proffesion = TextEditingController();

  String? _selectedState;
  String? _selectedCarType;
  String? _selectedDocumentType;
  String? _selectedType;
  List<String> _states = [];
  List<String> _car_types = [];
  List<String> _car_tax_amounts = [];
  List<String> _car_payment_times = [];
  int? _selectedCarIndex;

  String carTaxAmount = "";
  String TaxPaymentTime_based_on_car = "";

  List<String> _DocumentTypes = [];

  final List<String> _types = ["Employee", "Student", "Other"];

  bool _isLoading = true;

  Future<void> _loadStates() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.100.10/egov_back/states/'),
      );

      print(" The Response: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Assuming your states are in data['states'] as a list of names
          // final state = data['states'];
          List<dynamic> statesJson = data['states'];
          setState(() {
            // _states = [state['state_name']];
            _states =
                statesJson
                    .map((state) => state['state_name'] as String)
                    .toList();
            _isLoading = false;
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception("Failed To Fetch States: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> _loadDocumentTypes() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.100.10/egov_back/documentTypes/4'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> documentTypesJson = data['document_Types'];
          setState(() {
            _DocumentTypes =
                documentTypesJson
                    .map((type) => type['document_name'] as String)
                    .toList();
            _isLoading = false;
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
          "Failed To Fetch Document Types: ${response.statusCode}",
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> _loadCitizenData() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final citizenId = prefs.getInt('user_id');

      if (citizenId == null) {
        throw Exception("User ID not found in preferences");
      }

      // Fetch citizen data
      final response = await http.get(
        Uri.parse('http://192.168.100.10/egov_back/citizen/$citizenId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            // fullName = data['data']['fullname'];
            // gender = data['data']['gender'];
            // phone = data['data']['phone'];
            // birthdate = data['data']['birthdate'];
            _Fullname.text = data['data']['fullname'];
            _phone.text = data['data']['phone'];
            _dob = DateFormat('yyyy-MM-dd').parse(data['data']['birthdate']);
            _isLoading = false;
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> _loadCarTypes() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.100.10/egov_back/car_types'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Assuming your states are in data['states'] as a list of names
          // final state = data['states'];
          List<dynamic> CarTypesJson = data['car_types'];
          setState(() {
            // _states = [state['state_name']];
            _car_types =
                CarTypesJson.map((type) => type['name'] as String).toList();
            _car_tax_amounts =
                CarTypesJson.map(
                  (amount) => amount['tax_amount'] as String,
                ).toList();
            _car_payment_times =
                CarTypesJson.map(
                  (paymentTime) => paymentTime['Payment_Timing'] as String,
                ).toList();
            _isLoading = false;
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception("Failed To Fetch Car Types: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  void _submitForm() async {
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');

    if (citizenId == null) {
      _showError("User ID not found in preferences");
      return;
    }

    if (_selectedDocumentType == null) {
      _showError('Fill The Required Fields');
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.100.10/egov_back/request_driverLicense'),
      );

      request.fields['citizen_id'] = citizenId.toString();
      request.fields['service_id'] = "2";

      request.fields['document_Type'] = _selectedDocumentType ?? '';

      request.fields['car_Type'] = _selectedCarType ?? '';
      request.fields['plate_number'] = _plate_number.text ?? '';
      request.fields['vehicle_color'] = _vehicle_color.text ?? '';


      // unnecessary requests
      request.fields['amount'] = carTaxAmount ?? '0';
      request.fields['due_date'] = TaxPaymentTime_based_on_car ?? '';


      if (_citizenImg != null) {
        request.files.add(
          await http.MultipartFile.fromPath('citizen_image', _citizenImg!.path),
        );
      }

      // birth or national id card document
      if (_document != null) {
        request.files.add(
          await http.MultipartFile.fromPath('document', _document!.path),
        );
      }

      // cid document
      if (_cid_document != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'cid_document',
            _cid_document!.path,
          ),
        );
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("Response: $responseBody");
      // print("Response: ${_document!.path}");
      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseBody);
        if (mounted) {
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return AlertDialog(
          //       title: Text("Success"),
          //       content: Text(responseData['message'] ?? "Request submitted."),
          //       actions: [
          //         TextButton(
          //           onPressed: () {
          //             Navigator.pop(context); // Close dialog
          //             Navigator.pop(context); // Go back
          //           },
          //           child: Text("OK"),
          //         ),
          //       ],
          //     );
          //   },
          // );
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Icon(
                    FontAwesomeIcons.squareCheck,
                    color: Colors.green,
                    size: 64,
                  ),
                  content: Text(
                    'Thank you for requesting our service',
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: TextButton(
                        onPressed: () {
                          // Navigate to home page after dialog is dismissed
                          Navigator.pushReplacementNamed(
                            context,
                            'home_screen',
                          );
                        },
                        child: Text('OK', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
          );
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Submission failed: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _loadStates();
    _loadDocumentTypes();
    _loadCitizenData();
    _loadCarTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fill Application Form"), centerTitle: true),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: NationalIDUploader(
                  buttonText: 'Photo',
                  height: 140,
                  width: 140,
                  icon: Icons.person,
                  onImageSelected: (file) => setState(() => _citizenImg = file),
                ),
              ),
            ),
            Text("Upload your profile photo (passport-style)."),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFields(
                input_controller: _Fullname,
                inputlabel: Text("Fullname / Magacaaga Sadexan"),
                prefixIcon: Icon(Bootstrap.person),
                suffixIcon: null,
                isPassword: false,
                validator: null,
                isEnabled: false,
              ),
            ),
            SizedBox(height: 5),

            _isLoading
                ? const CircularProgressIndicator()
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),

                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedCarType,
                      hint: Text('Car Type e.g (Private , Moto , Etc)'),
                      onChanged: (value) {
                        setState(() {
                          _selectedCarType = value;
                          _selectedCarIndex = _car_types.indexOf(value!);

                          // Fill tax amount and payment timing based on selection
                          carTaxAmount = _car_tax_amounts[_selectedCarIndex!].toString();
                          TaxPaymentTime_based_on_car =
                              _car_payment_times[_selectedCarIndex!];

                          print("Tax Amount is: $carTaxAmount");
                          print(
                            "Payment Timing is: $TaxPaymentTime_based_on_car",
                          );
                        });
                        // widget.onChanged(value);
                      },

                      items:
                          _car_types.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                    ),
                  ),
                ),

            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFields(
                input_controller: _plate_number,
                inputlabel: Text("Plate Number / Targada Gaadiidka"),
                prefixIcon: Icon(Bootstrap.car_front),
                suffixIcon: null,
                isPassword: false,
                validator: null,
                isEnabled: true,
              ),
            ),

            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFields(
                input_controller: _vehicle_color,
                inputlabel: Text("Vehicle Color / Midabka Gaadiidka"),
                prefixIcon: Icon(FontAwesomeIcons.carSide),
                suffixIcon: null,
                isPassword: false,
                validator: null,
                isEnabled: true,
              ),
            ),

            SizedBox(height: 5),

            _isLoading
                ? const CircularProgressIndicator()
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),

                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedDocumentType,
                      hint: Text('Select Document Type'),
                      onChanged: (value) {
                        setState(() => _selectedDocumentType = value);
                        // widget.onChanged(value);
                      },

                      items:
                          _DocumentTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                    ),
                  ),
                ),
            SizedBox(height: 10),
            DocumentUploader(
              onFileSelected: (file) {
                if (file != null) {
                  _document = File(file.path!);
                  print("File Path Found");
                }
              },
              initialPlaceholderText:
                  'Upload ${_selectedDocumentType ?? "Document"}',
            ),

            SizedBox(height: 10),
            DocumentUploader(
              onFileSelected: (file) {
                if (file != null) {
                  _cid_document = File(file.path!);
                  print("File Path Found");
                }
              },
              initialPlaceholderText: 'Upload CID Document',
            ),

            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Background color (primary blue)
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // 8px border radius
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                    ), // Optional: Adjust padding
                  ),
                  child: Text(
                    "Request Driver License",

                    style: TextStyle(
                      fontSize: 16,
                    ), // Optional: Adjust text size
                  ),
                ),
              ),
            ),

            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      FontAwesomeIcons.info,
                      color: Colors.blueAccent,
                      size: 18,
                    ),
                    Text(
                      "The personal information you provided will be used \nto process your national ID card request,\n in accordance with data protection laws.",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
