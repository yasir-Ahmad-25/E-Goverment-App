import 'dart:convert';
import 'dart:io';

import 'package:e_govermenet/components/date_input_field.dart';
import 'package:e_govermenet/components/gender_dropdown.dart';
import 'package:e_govermenet/components/national_id_uploader.dart';
import 'package:e_govermenet/components/input_fields.dart';
import 'package:e_govermenet/components/martial_status_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Text controllers
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _nationalID = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _shownpass = false;
  bool _shownConfirmPass = false;
  // Form values
  String _gender = 'Male';
  String _maritalStatus = 'Single';
  DateTime? _dob;
  File? _frontNationalID;
  File? _backNationalID;

  // Form validation
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Here we have created list of steps that
  // are required to complete the form
  List<Step> stepList() => [
    // Personal Info
    Step(
      state: _ActiveCurrentStep <= 0 ? StepState.editing : StepState.complete,
      isActive: _ActiveCurrentStep >= 0,
      title: const Text('Personal Info'),
      content: Column(
        children: [
          InputFields(
            input_controller: _fullname,
            inputlabel: Text('Enter Fullname'),
            prefixIcon: Icon(Icons.person),
            suffixIcon: null,
            isPassword: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          SizedBox(height: 15),

          InputFields(
            input_controller: _email,
            inputlabel: Text('Enter Email'),
            prefixIcon: Icon(Icons.mail),
            suffixIcon: null,
            isPassword: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          SizedBox(height: 15),

          InputFields(
            input_controller: _phone,
            inputlabel: Text('Enter Phone Number'),
            prefixIcon: Icon(Icons.phone),
            suffixIcon: null,
            isPassword: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          SizedBox(height: 15),

          GenderDropdown(
            selectedGender: _gender,
            onChanged: (value) => setState(() => _gender = value!),
          ),

          const SizedBox(height: 20),

          MaritalStatusDropdown(
            selectedStatus: _maritalStatus,
            onChanged: (value) => setState(() => _maritalStatus = value!),
          ),
        ],
      ),
    ),

    // Step 2 Identity Verification
    Step(
      state: _ActiveCurrentStep <= 1 ? StepState.editing : StepState.complete,
      isActive: _ActiveCurrentStep >= 1,
      title: const Text('Identity'),
      content: Column(
        children: [
          DateInputField(
            selectedDate: _dob,
            onChanged: (date) => setState(() => _dob = date),
            labelText: 'Date of Birth',
          ),

          SizedBox(height: 20),

          InputFields(
            input_controller: _nationalID,
            inputlabel: Text("Enter National Id Number"),
            prefixIcon: null,
            isPassword: false,
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.idCard),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'National ID is required';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          NationalIDUploader(
            buttonText: 'Upload Front Side',
            height: 250,
            icon: Icons.credit_card,
            onImageSelected: (file) => setState(() => _frontNationalID = file),
          ),
          const SizedBox(height: 20),
          NationalIDUploader(
            buttonText: 'Upload Back Side',
            height: 250,
            icon: Icons.credit_card,
            onImageSelected: (file) => setState(() => _backNationalID = file),
          ),
        ],
      ),
    ),

    // Account Creation
    Step(
      state: StepState.complete,
      isActive: _ActiveCurrentStep >= 2,
      title: const Text('Set Up'),
      content: Column(
        children: [
          InputFields(
            input_controller: _username,
            inputlabel: Text('Enter Username'),
            prefixIcon: Icon(Icons.person),
            suffixIcon: null,
            isPassword: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username is required';
              }
              return null;
            },
          ),

          SizedBox(height: 15),

          InputFields(
            input_controller: _password,
            inputlabel: Text('Enter Passoword'),
            prefixIcon: null,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _shownpass = !_shownpass;
                });
              },
              icon: Icon(FontAwesomeIcons.lock),
            ),
            isPassword: _shownpass,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          SizedBox(height: 15),

          InputFields(
            input_controller: _confirmPassword,
            inputlabel: Text('Enter Confirm Password'),
            prefixIcon: null,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _shownConfirmPass = !_shownConfirmPass;
                });
              },
              icon: Icon(FontAwesomeIcons.lock),
            ),
            isPassword: _shownConfirmPass,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              } else if (value != _password.text) {
                return 'Password Should Match !';
              }
              return null;
            },
          ),
        ],
      ),
    ),
  ];

  var _ActiveCurrentStep = 0;

  // void _submitForm() async {
  //   if (_formKey.currentState!.validate()) {
  //     // Additional validation for non-form fields
  //     if (_dob == null) {
  //       _showError('Date of Birth is required');
  //       return;
  //     }
  //     if (_frontNationalID == null || _backNationalID == null) {
  //       _showError('Both ID card sides are required');
  //       return;
  //     }

  //     setState(() => _isLoading = true);

  //     try {
  //       var request = http.MultipartRequest(
  //         'POST',
  //         // Uri.parse('https://your-backend-url.com/signup'),
  //         Uri.parse('http://192.168.100.10/egov_back/signup'),
  //       );

  //       // Add text fields
  //       request.fields['fullname'] = _fullname.text;
  //       request.fields['email'] = _email.text;
  //       request.fields['phone'] = _phone.text;
  //       request.fields['gender'] = _gender;
  //       request.fields['marital_status'] = _maritalStatus;
  //       request.fields['dob'] = _dob!.toIso8601String();
  //       request.fields['national_id'] = _nationalID.text;
  //       request.fields['username'] = _username.text;
  //       request.fields['password'] = _password.text;

  //       // Add images
  //       if (_frontNationalID != null) {
  //         request.files.add(
  //           await http.MultipartFile.fromPath(
  //             'front_national_id',
  //             _frontNationalID!.path,
  //             contentType: MediaType('image', 'jpeg'),
  //           ),
  //         );
  //       }
  //       if (_backNationalID != null) {
  //         request.files.add(
  //           await http.MultipartFile.fromPath(
  //             'back_national_id',
  //             _backNationalID!.path,
  //             contentType: MediaType('image', 'jpeg'),
  //           ),
  //         );
  //       }

  //       // Send request
  //       var response = await request.send();
  //       var responseBody = await response.stream.bytesToString();

  //       if (mounted && response.statusCode == 201) {
  //         final data = jsonDecode(responseBody);
  //         final prefs = await SharedPreferences.getInstance();

  //         await prefs.setInt('user_id', data['user']['id']);
  //         await prefs.setString('email', data['user']['email']);
  //         if (mounted) {
  //           Navigator.pushReplacementNamed(context, 'home_screen');
  //         }
  //       } else {
  //         throw Exception('Server error: ${response.statusCode}');
  //       }
  //     } catch (e) {
  //       _showError('Submission failed: ${e.toString()}');
  //     } finally {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Validate all required fields
      if (_fullname.text.isEmpty ||
          _email.text.isEmpty ||
          _username.text.isEmpty ||
          _password.text.isEmpty ||
          _confirmPassword.text.isEmpty ||
          _frontNationalID == null ||
          _backNationalID == null) {
        _showError('Please fill all required fields');
        return;
      }

      // Validate password match
      if (_password.text != _confirmPassword.text) {
        _showError('Passwords do not match');
        return;
      }

      if (kDebugMode) {
        print("VAR VALUES : ${_fullname.text}, ${_email.text} , ${_frontNationalID},${_backNationalID}, ${_password.text} , ${_confirmPassword.text} , $_dob , ${_nationalID.text}");
      }
      if (_dob == null) {
        _showError('Date of Birth is required');
        return;
      }

      // Validate images

      if (_frontNationalID == null || _backNationalID == null) {
        _showError('Both ID card sides are required');
        return;
      }

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://192.168.100.10/egov_back/signup'),
        );

        // Add text fields
        request.fields['fullname'] = _fullname.text;
        request.fields['email'] = _email.text;
        request.fields['phone'] = _phone.text;
        request.fields['gender'] = _gender;
        request.fields['martial_status'] = _maritalStatus;
        request.fields['dob'] = _dob!.toIso8601String();
        request.fields['national_id'] = _nationalID.text;
        request.fields['username'] = _username.text; // Add username
        request.fields['password'] = _password.text; // Add password

        // Add images
        if (_frontNationalID != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'front_national_id',
              _frontNationalID!.path,
            ),
          );
        }
        if (_backNationalID != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'back_national_id',
              _backNationalID!.path,
            ),
          );
        }

        // Send request
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        if (response.statusCode == 201) {
          final data = jsonDecode(responseBody);
          final prefs = await SharedPreferences.getInstance();

          // Save user data
          await prefs.setInt('user_id', data['user']['id']);
          await prefs.setString('email', data['user']['email']);

          if (mounted) {
            Navigator.pushReplacementNamed(context, 'home_screen');
          }
        } else {
          if(kDebugMode){
            print('Server response: $responseBody');
          }
          throw Exception('Server error: ${response.statusCode}');
          
        }
      } catch (e) {
        _showError('Submission failed: ${e.toString()}');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stepper(
            elevation: 0,

            type: StepperType.horizontal,
            currentStep: _ActiveCurrentStep,
            onStepContinue: () {
              if (_ActiveCurrentStep != stepList().length - 1) {
                _formKey.currentState!.validate();
                setState(() => _ActiveCurrentStep += 1);
              } else {
                _submitForm();
              }
            },

            onStepCancel: () {
              if (_ActiveCurrentStep == 0) {
                return;
              }

              setState(() {
                _ActiveCurrentStep -= 1;
              });
            },

            onStepTapped: (int index) {
              setState(() {
                _ActiveCurrentStep = index;
              });
            },
            steps: stepList(),
          ),
        ),
      ),
    );
  }
}
