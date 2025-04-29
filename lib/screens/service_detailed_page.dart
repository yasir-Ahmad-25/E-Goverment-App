import 'dart:convert';

import 'package:e_govermenet/components/banner_card.dart';
import 'package:flutter/material.dart';
import 'package:e_govermenet/components/request_card.dart';
import 'package:e_govermenet/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceDetailPage extends StatefulWidget {
  final GovService service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  bool hasNationalId = false;
  String RequesStatus = "";

  // Create controllers for each field
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _maritalStatusController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadServiceData();
    // Set initial text values (replace with your data)
    _cardNumberController.text = '1234 5678 9012 3456';
    _issueDateController.text = '01/01/2023';
    _expiryDateController.text = '12/31/2028';
    _fullNameController.text = 'John Doe';
    _birthDateController.text = '05/15/1990';
    _genderController.text = 'Male';
    _maritalStatusController.text = 'Single';
  }

  Future<void> _loadServiceData() async {
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');

    try {
      // Fetch services data
      var response = await http.post(
        Uri.parse('http://192.168.100.10/egov_back/getCustomerService'),
        body: {
          'citizen_id': citizenId.toString(),
          'service_id': (widget.service.serId).toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            hasNationalId = true;
            RequesStatus = data['data'][0]['Request_Status'];
          });
        } else {
          setState(() {
            hasNationalId = false;
            RequesStatus = "NEW";
          });
          // throw data['message'];
        }
      } else {
        throw Exception(" Failed Please Try Again Later ?");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
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
    print("National id: $hasNationalId Request Status: $RequesStatus");
    return Scaffold(
      appBar: AppBar(title: Text(widget.service.name), centerTitle: true),
      body: SingleChildScrollView(
        // for better UX on small screens
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Conditional block for National ID
            if (widget.service.serId == 1) ...[
              NationalIdCard(
                hasNationalId: hasNationalId,
                requestStatus: RequesStatus,
                
                cardNumberController: _cardNumberController,
                issueDateController: _issueDateController,
                expiryDateController: _expiryDateController,
                fullNameController: _fullNameController,
                birthDateController: _birthDateController,
                genderController: _genderController,
                maritalStatusController: _maritalStatusController,
              ), // Centered RequestCard widget
            ],
          ],
        ),
      ),
    );
  }
}

class NationalIdCard extends StatelessWidget {
  final bool hasNationalId;
  final String requestStatus;

  final TextEditingController cardNumberController;
  final TextEditingController issueDateController;
  final TextEditingController expiryDateController;
  final TextEditingController fullNameController;
  final TextEditingController birthDateController;
  final TextEditingController genderController;
  final TextEditingController maritalStatusController;

  const NationalIdCard({
    super.key,
    required this.hasNationalId,
    required this.requestStatus,
    required this.cardNumberController,
    required this.issueDateController,
    required this.expiryDateController,
    required this.fullNameController,
    required this.birthDateController,
    required this.genderController,
    required this.maritalStatusController,
  });

  @override
  Widget build(BuildContext context) {
    if (hasNationalId) {
      // check the request status
      if (requestStatus == 'Approved') {
        return PageContent(
          cardNumberController: cardNumberController,
          issueDateController: issueDateController,
          expiryDateController: expiryDateController,
          fullNameController: fullNameController,
          birthDateController: birthDateController,
          genderController: genderController,
          maritalStatusController: maritalStatusController,
        );
      } else {
        return Center(
          // Center directly here
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 150.0), // Add space
            child: RequestCard(
              card_title: 'Please Wait For Approval',
              card_text:
                  'Muwaadin Fadlan Sug inta Laga Xaqiijinaayo Codsigaaga Dalabashada Card ka',
              showRequestButton: false,
            ),
          ),
        );
      }
    }

    return Center(
      // Center directly here
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 150.0), // Add space
        child: RequestCard(
          card_title: 'Request National ID Card',
          card_text:
              'Muwaadin Hada Dalbo National Id Card Cadeynaya inaa Somali Tahay ?',
          showRequestButton: true,
        ),
      ),
    );
  }
}

class PageContent extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController issueDateController;
  final TextEditingController expiryDateController;
  final TextEditingController fullNameController;
  final TextEditingController birthDateController;
  final TextEditingController genderController;
  final TextEditingController maritalStatusController;
  const PageContent({
    super.key,
    required this.cardNumberController,
    required this.issueDateController,
    required this.expiryDateController,
    required this.fullNameController,
    required this.birthDateController,
    required this.genderController,
    required this.maritalStatusController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        National_ID_CARD_STRUCTURE(),
        SizedBox(height: 40),
        Card_Details(
          cardNumberController: cardNumberController,
          issueDateController: issueDateController,
          expiryDateController: expiryDateController,
          fullNameController: fullNameController,
          birthDateController: birthDateController,
          genderController: genderController,
          maritalStatusController: maritalStatusController,
        ),
      ],
    );
  }
}
 
// components

class National_ID_CARD_STRUCTURE extends StatelessWidget {
  const National_ID_CARD_STRUCTURE({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      // child: Image.asset(""),
    );
  }
}

class Card_Details extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController issueDateController;
  final TextEditingController expiryDateController;
  final TextEditingController fullNameController;
  final TextEditingController birthDateController;
  final TextEditingController genderController;
  final TextEditingController maritalStatusController;
  const Card_Details({
    super.key,
    required this.cardNumberController,
    required this.issueDateController,
    required this.expiryDateController,
    required this.fullNameController,
    required this.birthDateController,
    required this.genderController,
    required this.maritalStatusController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Card-Details",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Divider(),
        _buildTextField(
          controller: cardNumberController,
          icon: Icons.credit_card,
          label: 'Card Number',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: issueDateController,
          icon: Icons.calendar_today,
          label: 'Date of Issue',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: expiryDateController,
          icon: Icons.calendar_month,
          label: 'Date of Expiry',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: fullNameController,
          icon: Icons.person,
          label: 'Full Name',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: birthDateController,
          icon: Icons.cake,
          label: 'Birthdate',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: genderController,
          icon: Icons.people,
          label: 'Gender',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: maritalStatusController,
          icon: Icons.people_alt,
          label: 'Marital Status',
        ),
      ],
    );
  }
}

// Reusable text field builder
Widget _buildTextField({
  required TextEditingController controller,
  required IconData icon,
  required String label,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    readOnly: true, // Make fields non-editable (if needed)
  );
}
