import 'dart:convert';
import 'dart:io';

import 'package:e_govermenet/components/date_input_field.dart';
import 'package:e_govermenet/components/document_uploader.dart';
import 'package:e_govermenet/components/gender_dropdown.dart';
import 'package:e_govermenet/components/input_fields.dart';
import 'package:e_govermenet/components/national_id_uploader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';

class NationalIdCardForm extends StatefulWidget {
  const NationalIdCardForm({super.key});

  @override
  State<NationalIdCardForm> createState() => _NationalIdCardFormState();
}

class _NationalIdCardFormState extends State<NationalIdCardForm> {
  File? _citizenImg;
  File? _BirhtDocument;

  DateTime? _dob;

  bool showOtherField = false;

  final TextEditingController _Fullname = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _mother_name = TextEditingController();
  final TextEditingController _father_name = TextEditingController();
  final TextEditingController _parent_no = TextEditingController();
  final TextEditingController _partnet_no_2 = TextEditingController();

  final TextEditingController _birthDate = TextEditingController();
  final TextEditingController _birthPlace = TextEditingController();
  final TextEditingController _martialStatus = TextEditingController();

  final TextEditingController _citizen_work_status = TextEditingController();

  String? _selectedState;
  String? _selectedType;
  List<String> _states = [];
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

  @override
  void initState() {
    super.initState();
    _loadStates();
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
            ),
          ),

          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFields(
              input_controller: _phone,
              inputlabel: Text(" Phone Number / Talefan Nambar "),
              prefixIcon: Icon(Icons.phone),
              suffixIcon: null,
              isPassword: false,
              validator: null,
            ),
          ),

          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DateInputField(
              selectedDate: _dob,
              onChanged: (date) => setState(() => _dob = date),
              labelText: 'Birth Date',
            ),
          ),

          SizedBox(height: 15),
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
          SizedBox(height: 15),
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
          SizedBox(height: 15),
          showOtherField
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputFields(
                  input_controller: _Fullname,
                  inputlabel: Text(
                    "Type Proffesion Here / Ku Qor Shaqada inta ?",
                  ),
                  prefixIcon: Icon(Bootstrap.person_workspace),
                  suffixIcon: null,
                  isPassword: false,
                  validator: null,
                ),
              )
              : SizedBox(height: 15),
          DocumentUploader(
            onFileSelected: (file) {
              if (file != null) {
                print("File path: ${file.path}");
                // You can now upload it to your server
              }
            },
          ),
        ],
      ),
    );
  }
}
