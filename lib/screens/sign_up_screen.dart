import 'dart:io';

import 'package:e_govermenet/components/date_input_field.dart';
import 'package:e_govermenet/components/gender_dropdown.dart';
import 'package:e_govermenet/components/national_id_uploader.dart';
import 'package:e_govermenet/components/input_fields.dart';
import 'package:e_govermenet/components/martial_status_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController nationalID = TextEditingController();

  String _gender = 'Male';
  String _maritalStatus = 'Single';

  bool shownpass = false;
  bool shownConfirmPass = false;

  File? _nationalIDImage;

  DateTime? _dob;
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
            input_controller: fullname,
            inputlabel: Text('Enter Fullname'),
            prefixIcon: Icon(Icons.person),
            suffixIcon: null,
            isPassword: false,
          ),

          SizedBox(height: 15),

          InputFields(
            input_controller: email,
            inputlabel: Text('Enter Email'),
            prefixIcon: Icon(Icons.mail),
            suffixIcon: null,
            isPassword: false,
          ),

          SizedBox(height: 15),

          InputFields(
            input_controller: phone,
            inputlabel: Text('Enter Phone Number'),
            prefixIcon: Icon(Icons.phone),
            suffixIcon: null,
            isPassword: false,
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
            input_controller: nationalID,
            inputlabel: Text("Enter National Id Number"),
            prefixIcon: null,
            isPassword: false,
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.idCard),
            ),
          ),

          const SizedBox(height: 20),

          NationalIDUploader(
            buttonText: 'Upload Front Side',
            height: 250,
            icon: Icons.credit_card,
            onImageSelected: (file) => setState(() => _nationalIDImage = file),
          ),
          const SizedBox(height: 20),
          NationalIDUploader(
            buttonText: 'Upload Back Side',
            height: 250,
            icon: Icons.credit_card,
            onImageSelected: (file) => setState(() => _nationalIDImage = file),
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
            input_controller: fullname,
            inputlabel: Text('Enter Username'),
            prefixIcon: Icon(Icons.person),
            suffixIcon: null,
            isPassword: false,
          ),

          SizedBox(height: 15),

          InputFields(
            input_controller: email,
            inputlabel: Text('Enter Passoword'),
            prefixIcon: null,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  shownpass = !shownpass;
                });
              },
              icon: Icon(FontAwesomeIcons.lock),
            ),
            isPassword: shownpass,
          ),

          SizedBox(height: 15),

          InputFields(
            input_controller: phone,
            inputlabel: Text('Enter Confirm Password'),
            prefixIcon: null,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  shownConfirmPass = !shownConfirmPass;
                });
              },
              icon: Icon(FontAwesomeIcons.lock),
            ),
            isPassword: shownConfirmPass,
          ),
        ],
      ),
    ),
  ];

  var _ActiveCurrentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stepper(
          elevation: 0,

          type: StepperType.horizontal,
          currentStep: _ActiveCurrentStep,
          onStepContinue: () {
            if (_ActiveCurrentStep < (stepList().length - 1)) {
              setState(() {
                _ActiveCurrentStep += 1;
              });
            } else {
              Navigator.pushReplacementNamed(context, 'home_screen');
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
    );
  }
}
