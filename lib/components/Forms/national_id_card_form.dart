import 'dart:convert';
import 'dart:io';

import 'package:e_govermenet/components/date_input_field.dart';
import 'package:e_govermenet/components/document_uploader.dart';
import 'package:e_govermenet/components/gender_dropdown.dart';
import 'package:e_govermenet/components/input_fields.dart';
import 'package:e_govermenet/components/national_id_uploader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NationalIdCardForm extends StatefulWidget {
  const NationalIdCardForm({super.key});

  @override
  State<NationalIdCardForm> createState() => _NationalIdCardFormState();
}

class _NationalIdCardFormState extends State<NationalIdCardForm> {
  String? fullName;
  String? gender;
  String? phone;
  String? birthdate;

  File? _citizenImg;
  File? _document;

  DateTime? _dob;

  bool showOtherField = false;

  final TextEditingController _Fullname = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  final TextEditingController _proffesion = TextEditingController();

  String? _selectedState;
  String? _selectedDocumentType;
  String? _selectedType;
  List<String> _states = [];
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
        Uri.parse('http://192.168.100.10/egov_back/documentTypes/3'),
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

  void _submitForm() async {
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');

    if (citizenId == null) {
      _showError("User ID not found in preferences");
      return;
    }

    if (_selectedState == null || _selectedDocumentType == null) {
      _showError('Fill The Required Fields');
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.100.10/egov_back/national_id_card'),
      );

      request.fields['citizen_id'] = citizenId.toString();
      request.fields['service_id'] = "1";
      request.fields['issued_at_location'] = _selectedState ?? '';
      request.fields['proffesion'] = _selectedDocumentType ?? _proffesion.text;
      request.fields['document_Type'] = _selectedDocumentType ?? '';

      if (_citizenImg != null) {
        request.files.add(
          await http.MultipartFile.fromPath('citizen_image', _citizenImg!.path),
        );
      }

      if (_document != null) {
        request.files.add(
          await http.MultipartFile.fromPath('document', _document!.path),
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

  // void _submitForm() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final citizenId = prefs.getInt('user_id');

  //   if (citizenId == null) {
  //     throw Exception("User ID not found in preferences");
  //   }

  //   if (_dob == null) {
  //     _showError('Date of Birth is required');
  //     return;
  //   }

  //   // Validate images

  //   if (_document == null) {
  //     _showError('Document is Required');
  //     return;
  //   }

  //   try {
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse('http://192.168.100.10/egov_back/national_id_card'),
  //     );

  //     // Add text fields
  //     request.fields['citizen_id'] = citizenId.toString();
  //     request.fields['service_id'] = "1";
  //     request.fields['birthState'] = _selectedState.toString();
  //     request.fields['proffesion'] = _proffesion.text;
  //     request.fields['document_Type'] = _selectedDocumentType.toString();

  //     // request.fields['document'] = _dob!.toIso8601String().substring(0, 10);

  //     // Add images
  //     if (_citizenImg != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           'citizen_image',
  //           _citizenImg!.path,
  //         ),
  //       );

  //       request.fields['citizen_image'] = _citizenImg!.path;
  //     }
  //     if (_document != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           'document',
  //           _document!.path,
  //         ),
  //       );
  //       request.fields['document'] = _document!.path;
  //     }

  //     // Send request
  //     var response = await request.send();
  //     var responseBody = await response.stream.bytesToString();

  //     if (response.statusCode == 200) {

  //       // Navigate
  //       if (mounted) {
  //         Navigator.pop(context);
  //       }
  //     } else {
  //       if (kDebugMode) {
  //         print('Server response: $responseBody');
  //       }
  //       throw Exception('Server error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     _showError('Submission failed: ${e.toString()}');
  //   }
  // }

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fill The Form"), centerTitle: true),

      body: Column(
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
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: InputFields(
          //     input_controller: _phone,
          //     inputlabel: Text(" Phone Number / Talefan Nambar "),
          //     prefixIcon: Icon(Icons.phone),
          //     suffixIcon: null,
          //     isPassword: false,
          //     validator: null,
          //     isEnabled: false,
          //   ),
          // ),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: DateInputField(
          //     selectedDate: _dob,
          //     onChanged: (date) => setState(() => _dob = date),
          //     labelText: 'Birth Date',
          //     enabled: false,
          //   ),
          // ),

          // SizedBox(height: 5),
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
                    value: _selectedState,
                    hint: Text('Select State'),
                    onChanged: (value) {
                      setState(() => _selectedState = value);
                      // widget.onChanged(value);
                    },

                    items:
                        _states.map((state) {
                          return DropdownMenuItem(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                  ),
                ),
              ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),

              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedType,
                hint: Text('Select Professional Status'),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                    if (value == "Other") {
                      showOtherField = true;
                    } else {
                      showOtherField = false;
                    }
                  });
                  // widget.onChanged(value);
                },

                items:
                    _types.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
              ),
            ),
          ),

          // SizedBox(height: 5),
          showOtherField
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputFields(
                  input_controller: _proffesion,
                  inputlabel: Text(
                    "Type Proffesion Here / Ku Qor Shaqada inta ?",
                  ),
                  prefixIcon: Icon(FontAwesome.briefcase_solid),
                  suffixIcon: null,
                  isPassword: false,
                  validator: null,
                  isEnabled: true,
                ),
              )
              : SizedBox(height: 5),

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
            }, initialPlaceholderText: 'Upload $_selectedDocumentType',
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
                    borderRadius: BorderRadius.circular(8), // 8px border radius
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ), // Optional: Adjust padding
                ),
                child: Text(
                  "Request Card",
                  style: TextStyle(fontSize: 16), // Optional: Adjust text size
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
    );
  }
}
