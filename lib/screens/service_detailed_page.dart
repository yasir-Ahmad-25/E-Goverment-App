import 'dart:convert';

import 'package:e_govermenet/components/banner_card.dart';
import 'package:e_govermenet/components/collapsible_widget.dart';
import 'package:e_govermenet/screens/approved_screens/passport_page.dart';
import 'package:flutter/material.dart';
import 'package:e_govermenet/components/request_card.dart';
import 'package:e_govermenet/screens/home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceDetailPage extends StatefulWidget {
  final GovService service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  // ================================== PASSPORT SECTION START ===================================
  List<String> Questions = [
    'What is a passport and why do I need one ?',
    'How do I apply for a passport ? ',
    'What documents are required to apply ? ',
    'How long does it take to receive my passport ? ',
    'Can I renew my passport before it expires ? ',
    'What should I do if my passport is lost or stolen ? ',
  ];

  List<String> Answers = [
    "A passport is an official travel document issued by a government, allowing you to travel internationally and proving your identity and citizenship.",
    "You can apply by clicking the “Request Passport” button and filling in your personal details, uploading required documents, and submitting the form.",
    "Typically, you’ll need a national ID, birth certificate, and a recent passport-sized photo. Requirements may vary.",
    "Processing time usually ranges from 2 to 6 weeks depending on the application volume and your location.",
    "Yes, it’s recommended to renew it 6 months before expiration to avoid travel issues.",
    "Report it immediately to the relevant authorities and reapply for a new one through the system.",
  ];
  // ================================== PASSPORT SECTION END ===================================

  // ================================== BIRTH CERTIFICATE SECTION START ===================================
  List<String> birthcertificate_Questions = [
    'What is a birth certificate and why do I need one?',
    'How do I apply for a birth certificate?',
    'What documents are required to apply?',
    'How long does it take to receive my birth certificate?',
    'Can I request a replacement if my birth certificate is damaged or lost?',
    'What should I do if I notice an error on my birth certificate?',
  ];

  List<String> birthcertificate_Answers = [
    "A birth certificate is an official document that records a person’s birth details, proving identity, age, and citizenship. It's essential for accessing government services, enrolling in school, and applying for legal documents.",
    "You can apply by clicking the “Request Birth Certificate” button and completing the online form with personal details, then submitting the required documents.",
    "Generally, you’ll need proof of identity (such as a national ID), and information about the birth (such as parents’ IDs and place/date of birth). Requirements may vary by region.",
    "Processing time typically ranges from a few days to a few weeks depending on the issuing authority and location.",
    "Yes, you can request a replacement by submitting a reissue application along with valid identification and a small fee, if applicable.",
    "If there’s an error, you should contact the issuing authority to request a correction and provide any supporting documents needed to verify the correct information.",
  ];

  final TextEditingController _birthCertificate_fullname =
      TextEditingController();
  final TextEditingController _birthCertificate_gender =
      TextEditingController();
  final TextEditingController _birthCertificate_state = TextEditingController();
  final TextEditingController _birthCertificate_proffession =
      TextEditingController();

  // ================================== BIRTH CERTIFICATE SECTION END ===================================

  // ================================== BUSINESS CERTIFICATE SECTION START ===================================
  List<String> BusinessQuestions = [
    'What is business registration and why is it important?',
    'How do I register my business?',
    'What documents are required for business registration?',
    'How long does the registration process take?',
    'Can I make changes to my business details after registration?',
    'What should I do if I lose my business registration certificate?',
  ];

  List<String> BusinessAnswers = [
    "Business registration is the process of officially recording your business with the government, making it a recognized legal entity. It is essential for complying with laws, opening bank accounts, and building credibility.",
    "You can register your business by clicking the “Register Business” button, filling in your business details, uploading required documents, and submitting the application.",
    "Required documents usually include a valid national ID, proof of business address, and business name details. Requirements may vary based on business type and location.",
    "The process typically takes a few days to a few weeks, depending on the application volume and your local authority's procedures.",
    "Yes, you can request updates such as changing the business name, address, or ownership details through the system, usually by submitting a modification request and supporting documents.",
    "If you lose your certificate, you can request a duplicate copy through the system by providing your registration number and valid identification.",
  ];

  final TextEditingController _business_fullname = TextEditingController();
  final TextEditingController _business_name = TextEditingController();

  // ================================== BUSINESS CERTIFICATE SECTION END ===================================

  List<String> driverLicenseQuestions = [
    'What is a driver’s license and why do I need one?',
    'How do I apply for a driver’s license?',
    'What documents are required for a driver’s license?',
    'How long does it take to receive my driver’s license?',
    'Can I renew my driver’s license before it expires?',
    'What should I do if my driver’s license is lost or stolen?',
  ];

  List<String> driverLicenseAnswers = [
    "A driver’s license is an official document issued by the government that permits you to operate a motor vehicle legally and serves as a valid form of identification.",
    "You can apply by clicking the “Apply for Driver’s License” button, filling in your personal and vehicle details, uploading the required documents, and submitting the application.",
    "Typically, you’ll need a national ID, proof of residence, medical fitness certificate, and sometimes a learner’s permit or driving test result. Requirements may vary.",
    "Processing time usually ranges from a few days to a few weeks, depending on testing, verification, and local authority timelines.",
    "Yes, it is recommended to renew your license before it expires to avoid fines or legal issues. Most systems allow renewal within a set window before the expiry date.",
    "If your license is lost or stolen, report it to the authorities immediately and request a replacement by submitting the required details and identification.",
  ];

  bool hasNationalId = false;
  String RequesStatus = "";

  // Create controllers for each field
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _IdNumber = TextEditingController();
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

            if (widget.service.serId == 2) ...[
              Passport(
                hasPassport: true,
                requestStatus: "Approved",
                Questions: Questions,
                Answers: Answers,
              ),
            ],

            if (widget.service.serId == 3) ...[
              BirthCertificate(
                hasBirthCertificate: true,
                birthcertificate_requestStatus: "Approved",
                birthcertificate_Questions: birthcertificate_Questions,
                birthcertificate_Answers: birthcertificate_Answers,
                birthCertificate_fullname: _birthCertificate_fullname,
                birthCertificate_gender: _birthCertificate_gender,
                birthCertificate_state: _birthCertificate_state,
                birthCertificate_proffession: _birthCertificate_proffession,
              ),
            ],

            if (widget.service.serId == 4) ...[
              Business(
                hasBusiness: true,
                Business_requestStatus: "Approved",
                BusinessQuestions: BusinessQuestions,
                BusinessAnswers: BusinessAnswers,
                business_fullname: _business_fullname,
                business_name: _business_name,
              ),
            ],

            if (widget.service.serId == 5) ...[
              DrivingLicense(
                cardNumberController: _cardNumberController,
                issueDateController: _issueDateController,
                expiryDateController: _expiryDateController,
                fullNameController: _fullNameController,
                birthDateController: _birthDateController,
                genderController: _genderController,
                maritalStatusController: _maritalStatusController,
                hasDrivingLicense: true,
                DriverLicenseQuestions: driverLicenseQuestions,
                DriverLicenseAnswers: driverLicenseAnswers,
                driverLicense_requestStatus: "Approved",
              ),
            ],
            if (widget.service.serId == 6) ...[
              ManageEducationCertification(IdNumber: _IdNumber),
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
      height: 230, // Increased height
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section with Flag and Country Names
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://www.ecss-online.com/2013/wp-content/uploads/2022/12/somalia.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: const [
                  Text(
                    "Jamhuuriyada Federalka Somalia",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "جمهورية الصومال الفيدرالية",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Federal Republic of Somalia",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          const Divider(thickness: 1, color: Colors.grey),

          // Content Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Content Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Identity and Name Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem("Identity No:", "90294672"),
                        _buildInfoItem("Full Name:", "Yasir Ahmad Yahya"),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Gender and Birthdate Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem("Gender:", "Male"),
                        _buildInfoItem("DOB:", "01/01/1990"),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Issue/Expiry Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem("Issued:", "01/01/2020"),
                        _buildInfoItem("Expires:", "01/01/2030"),
                      ],
                    ),
                  ],
                ),
              ),

              // Profile Image
              Container(
                margin: const EdgeInsets.only(left: 16),
                width: 100,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://www.ecss-online.com/2013/wp-content/uploads/2022/12/somalia.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
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

// ================================ PASSPORT SECTION =============================================
class Passport extends StatelessWidget {
  final bool hasPassport;
  final String requestStatus;
  final List<String> Questions;
  final List<String> Answers;

  // final TextEditingController cardNumberController;
  // final TextEditingController issueDateController;
  // final TextEditingController expiryDateController;
  // final TextEditingController fullNameController;
  // final TextEditingController birthDateController;
  // final TextEditingController genderController;
  // final TextEditingController maritalStatusController;

  const Passport({
    super.key,
    required this.hasPassport,
    required this.requestStatus,
    required this.Questions,
    required this.Answers,
  });

  @override
  Widget build(BuildContext context) {
    print("Does it have: $hasPassport the request status is: $requestStatus");
    if (hasPassport) {
      // check the request status
      if (requestStatus == 'Approved') {
        // return Text("Passport Approved");
        return PassportPage();
        // return PageContent(
        //   cardNumberController: cardNumberController,
        //   issueDateController: issueDateController,
        //   expiryDateController: expiryDateController,
        //   fullNameController: fullNameController,
        //   birthDateController: birthDateController,
        //   genderController: genderController,
        //   maritalStatusController: maritalStatusController,
        // );
      } else {
        return Text("Please Wait For Approval");
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 280,
            child: Image.asset("assets/images/passport.jpg"),
          ),
        ),

        Center(
          child: Text(
            "A passport is your gateway to global travel and identity verification. Apply today to access international opportunities with ease",
          ),
        ),

        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // onPressed: _submitForm,
              onPressed: () {
                Navigator.pushNamed(context, 'passport_form');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color (primary blue)
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 8px border radius
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ), // Optional: Adjust padding
              ),
              child: Text(
                "Request Passport",
                style: TextStyle(fontSize: 16), // Optional: Adjust text size
              ),
            ),
          ),
        ),

        SizedBox(height: 10),
        Text(
          "FAQ`s",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Divider(),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: Questions[0],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(Answers[0])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: Questions[1],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(Answers[1])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: Questions[2],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(Answers[2])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: Questions[3],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(Answers[3])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: Questions[4],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(Answers[4])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: Questions[5],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(Answers[5])],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

// ================================ BIRTH CERTIFICATE STARTS =============================================

class BirthCertificate extends StatelessWidget {
  final bool hasBirthCertificate;
  final String birthcertificate_requestStatus;
  final List<String> birthcertificate_Questions;
  final List<String> birthcertificate_Answers;

  final TextEditingController birthCertificate_fullname;
  final TextEditingController birthCertificate_gender;
  final TextEditingController birthCertificate_state;
  final TextEditingController birthCertificate_proffession;

  const BirthCertificate({
    super.key,
    required this.hasBirthCertificate,
    required this.birthcertificate_requestStatus,
    required this.birthcertificate_Questions,
    required this.birthcertificate_Answers,
    required this.birthCertificate_fullname,
    required this.birthCertificate_gender,
    required this.birthCertificate_state,
    required this.birthCertificate_proffession,
  });

  @override
  Widget build(BuildContext context) {
    if (hasBirthCertificate) {
      // check the request status
      if (birthcertificate_requestStatus == 'Approved') {
        // return Text("Birth Certificate Approved");
        return BirthCertificate_Details(
          birthCertificate_fullname: birthCertificate_fullname,
          birthCertificate_gender: birthCertificate_gender,
          birthCertificate_state: birthCertificate_state,
          birthCertificate_proffession: birthCertificate_proffession,
        );
        // return PageContent(
        //   cardNumberController: cardNumberController,
        //   issueDateController: issueDateController,
        //   expiryDateController: expiryDateController,
        //   fullNameController: fullNameController,
        //   birthDateController: birthDateController,
        //   genderController: genderController,
        //   maritalStatusController: maritalStatusController,
        // );
      } else {
        return Text("Please Wait For Approval");
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 280,
            child: Image.asset("assets/images/birth_certificate.jpg"),
          ),
        ),

        Center(
          child: Text(
            "A birth certificate is your official proof of identity and citizenship. Secure yours today to access essential services and legal rights with confidence.",
          ),
        ),

        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // onPressed: _submitForm,
              onPressed: () {
                Navigator.pushNamed(context, 'birth_certificate_form');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color (primary blue)
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 8px border radius
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ), // Optional: Adjust padding
              ),
              child: Text(
                "Request Birth Certificate",
                style: TextStyle(fontSize: 16), // Optional: Adjust text size
              ),
            ),
          ),
        ),

        SizedBox(height: 10),
        Text(
          "FAQ`s",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Divider(),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: birthcertificate_Questions[0],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(birthcertificate_Answers[0])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: birthcertificate_Questions[1],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(birthcertificate_Answers[1])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: birthcertificate_Questions[2],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(birthcertificate_Answers[2])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: birthcertificate_Questions[3],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(birthcertificate_Answers[3])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: birthcertificate_Questions[4],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(birthcertificate_Answers[4])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: birthcertificate_Questions[5],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(birthcertificate_Answers[5])],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class BirthCertificate_Details extends StatelessWidget {
  final TextEditingController birthCertificate_fullname;
  final TextEditingController birthCertificate_gender;
  final TextEditingController birthCertificate_state;
  final TextEditingController birthCertificate_proffession;
  const BirthCertificate_Details({
    super.key,
    required this.birthCertificate_fullname,
    required this.birthCertificate_gender,
    required this.birthCertificate_state,
    required this.birthCertificate_proffession,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 280,
              child: Image.asset("assets/images/birth_certificate.jpg"),
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Birth Certificate - Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Divider(),
          _buildTextField(
            controller: birthCertificate_fullname,
            icon: Icons.person,
            label: 'Fullname',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: birthCertificate_gender,
            icon: Icons.person_2,
            label: 'Gender',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: birthCertificate_state,
            icon: Icons.place,
            label: 'Birth Place',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: birthCertificate_proffession,
            icon: FontAwesomeIcons.briefcase,
            label: 'Work Status',
          ),
        ],
      ),
    );
  }
}

// ================================ BIRTH CERTIFICATE ENDS =============================================

// ================================ BUSINESS STARTS =============================================

class Business extends StatelessWidget {
  final bool hasBusiness;
  final String Business_requestStatus;
  final List<String> BusinessQuestions;
  final List<String> BusinessAnswers;

  final TextEditingController business_fullname;
  final TextEditingController business_name;

  const Business({
    super.key,
    required this.hasBusiness,
    required this.Business_requestStatus,
    required this.BusinessQuestions,
    required this.BusinessAnswers,
    required this.business_fullname,
    required this.business_name,
  });

  @override
  Widget build(BuildContext context) {
    if (hasBusiness) {
      // check the request status
      if (Business_requestStatus == 'Approved') {
        // return Text("Birth Certificate Approved");
        return BusinessDetails(
          business_fullname: business_fullname,
          business_name: business_name,
        );
        // return PageContent(
        //   cardNumberController: cardNumberController,
        //   issueDateController: issueDateController,
        //   expiryDateController: expiryDateController,
        //   fullNameController: fullNameController,
        //   birthDateController: birthDateController,
        //   genderController: genderController,
        //   maritalStatusController: maritalStatusController,
        // );
      } else {
        return Text("Please Wait For Approval");
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 280,
            child: Image.asset("assets/images/business.jpg"),
          ),
        ),

        Center(
          child: Text(
            "A business registration is your official recognition by the government to legally operate. Register today to comply with regulations, build trust, and unlock business opportunities with confidence.",
          ),
        ),

        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // onPressed: _submitForm,
              onPressed: () {
                Navigator.pushNamed(context, 'business_form');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color (primary blue)
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 8px border radius
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ), // Optional: Adjust padding
              ),
              child: Text(
                "Request Birth Certificate",
                style: TextStyle(fontSize: 16), // Optional: Adjust text size
              ),
            ),
          ),
        ),

        SizedBox(height: 10),
        Text(
          "FAQ`s",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Divider(),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: BusinessQuestions[0],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(BusinessAnswers[0])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: BusinessQuestions[1],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(BusinessAnswers[1])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: BusinessQuestions[2],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(BusinessAnswers[2])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: BusinessQuestions[3],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(BusinessAnswers[3])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: BusinessQuestions[4],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(BusinessAnswers[4])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: BusinessQuestions[5],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(BusinessAnswers[5])],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class BusinessDetails extends StatelessWidget {
  final TextEditingController business_fullname;
  final TextEditingController business_name;

  const BusinessDetails({
    super.key,
    required this.business_fullname,
    required this.business_name,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 280,
              child: Image.asset("assets/images/birth_certificate.jpg"),
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Birth Certificate - Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Divider(),
          _buildTextField(
            controller: business_fullname,
            icon: Icons.person,
            label: 'Fullname',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: business_name,
            icon: FontAwesomeIcons.businessTime,
            label: 'Business Name',
          ),
        ],
      ),
    );
  }
}

// ================================ BUSINESS ENDS =============================================

// ================================ DRIVING LICENSE STARTS =============================================

class DrivingLicense extends StatelessWidget {
  final bool hasDrivingLicense;
  final String driverLicense_requestStatus;
  final List<String> DriverLicenseQuestions;
  final List<String> DriverLicenseAnswers;

  // final TextEditingController driver_fullname;
  // final TextEditingController LicensePlateNumber;
  // final TextEditingController vehicleType;
  // final TextEditingController vehicleColor;

  final TextEditingController cardNumberController;
  final TextEditingController issueDateController;
  final TextEditingController expiryDateController;
  final TextEditingController fullNameController;
  final TextEditingController birthDateController;
  final TextEditingController genderController;
  final TextEditingController maritalStatusController;

  const DrivingLicense({
    super.key,
    required this.hasDrivingLicense,
    required this.driverLicense_requestStatus,
    required this.DriverLicenseQuestions,
    required this.DriverLicenseAnswers,
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
    if (hasDrivingLicense) {
      // check the request status
      if (driverLicense_requestStatus == 'Approved') {
        return Column(
          children: [
            DriverLicenseIDStructure(),
            DriverLicenseDetails(
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
      } else {
        return Text("Please Wait For Approval");
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 280,
            child: Image.asset("assets/images/driver_License.jpg"),
          ),
        ),

        Center(
          child: Text(
            "A driver’s license is your official authorization to operate motor vehicles. Get yours today to drive legally, prove your identity, and access essential services with confidence.",
          ),
        ),

        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // onPressed: _submitForm,
              onPressed: () {
                Navigator.pushNamed(context, 'driver_License_form');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color (primary blue)
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 8px border radius
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ), // Optional: Adjust padding
              ),
              child: Text(
                "Request Driver License",
                style: TextStyle(fontSize: 16), // Optional: Adjust text size
              ),
            ),
          ),
        ),

        SizedBox(height: 10),
        Text(
          "FAQ`s",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Divider(),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: DriverLicenseQuestions[0],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(DriverLicenseAnswers[0])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: DriverLicenseQuestions[1],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(DriverLicenseAnswers[1])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: DriverLicenseQuestions[2],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(DriverLicenseAnswers[2])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: DriverLicenseQuestions[3],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(DriverLicenseAnswers[3])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: DriverLicenseQuestions[4],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(DriverLicenseAnswers[4])],
          ),
        ),
        SizedBox(height: 10),
        CollapsibleWidget(
          title: DriverLicenseQuestions[5],
          initiallyExpanded: false,
          animationDuration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(DriverLicenseAnswers[5])],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class DriverLicenseIDStructure extends StatelessWidget {
  const DriverLicenseIDStructure({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 230, // Increased height
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section with Flag and Country Names
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://www.ecss-online.com/2013/wp-content/uploads/2022/12/somalia.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: const [
                  Text(
                    "Jamhuuriyada Federalka Somalia",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "جمهورية الصومال الفيدرالية",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Federal Republic of Somalia",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          const Divider(thickness: 1, color: Colors.grey),

          // Content Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Content Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Identity and Name Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem("Identity No:", "90294672"),
                        _buildInfoItem("Full Name:", "Yasir Ahmad Yahya"),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Gender and Birthdate Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem("Gender:", "Male"),
                        _buildInfoItem("DOB:", "01/01/1990"),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Issue/Expiry Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem("Issued:", "01/01/2020"),
                        _buildInfoItem("Expires:", "01/01/2030"),
                      ],
                    ),
                  ],
                ),
              ),

              // Profile Image
              Container(
                margin: const EdgeInsets.only(left: 16),
                width: 100,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/person.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class DriverLicenseDetails extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController issueDateController;
  final TextEditingController expiryDateController;
  final TextEditingController fullNameController;
  final TextEditingController birthDateController;
  final TextEditingController genderController;
  final TextEditingController maritalStatusController;
  const DriverLicenseDetails({
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

// ================================ DRIVING LICENSE ENDS =============================================

class ManageEducationCertification extends StatelessWidget {
  final TextEditingController IdNumber;
  const ManageEducationCertification({super.key, required this.IdNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ID NUMBER"),
        _buildTextField(
          controller: IdNumber,
          icon: Icons.people_alt,
          label: 'Marital Status',
        ),

        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,

          child: ElevatedButton(
            onPressed: () {
              print("searching id number");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Background color (primary blue)
              foregroundColor: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // 8px border radius
              ),
              padding: EdgeInsets.symmetric(
                vertical: 16,
              ), // Optional: Adjust padding
            ),
            child: Text(
              "Search",

              style: TextStyle(fontSize: 16), // Optional: Adjust text size
            ),
          ),
        ),
      ],
    );
  }
}
