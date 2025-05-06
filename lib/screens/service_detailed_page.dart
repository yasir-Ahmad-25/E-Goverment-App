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

  String _passport_citizen_fullname = "";
  String _passport_citizen_gender = "";
  String _passport_birthState = "";
  String _passport_birth_date = "";
  String _passport_citizen_imagePath = "";
  String _passport_Number = "";
  String _passport_issued_At = "";
  String _passport_expire_At = "";

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
  String _birthCertificateScannedImagePath = "";

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
  final TextEditingController _business_address = TextEditingController();
  final TextEditingController _business_type = TextEditingController();
  final TextEditingController _business_start_date = TextEditingController();

  String _businessCertificateScannedImagePath = "";
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

  final String _driver_Citizen_imagePath = "";

  bool hasNationalId = false;
  bool hasPassportId = false; // For Passport
  bool hasBirthCertificate = false; // For Birth Certificate
  bool hasBusinessCertificate = false; // For Business Certificate
  bool hasDriverLicense = false; // For Driver License

  String RequesStatus = "";
  String _business_requestStatus = "";
  String _driverLicense_requestStatus = "";

  String National_Id_Card_Citizen_imagePath = "";
  bool is_National_Id_Card_Expired = false;
  bool is_Passport_Expired = false;
  bool is_Certificate_Expired = false;
  bool is_Business_Expired = false;

  // Create controllers for each field
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();

  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _DriverLicense_issueDateController =
      TextEditingController();
  final TextEditingController _DriverLicense_expiryDateController =
      TextEditingController();
  String Driver_citizen_image_path = "";
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _IdNumber = TextEditingController();
  final TextEditingController _maritalStatusController =
      TextEditingController();

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

  Future<void> _loadNationalIdCardData() async {
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');

    try {
      var response = await http.get(
        Uri.parse('http://192.168.100.10/egov_back/national_id/$citizenId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' &&
            data['national_id_data'] != null &&
            data['national_id_data'].isNotEmpty) {
          final nationalIdData = data['national_id_data'][0];

          // Check if the national_id_number is not "0" or empty
          if (isValidNationalId(nationalIdData['national_id_number'])) {
            // check if national id is Expired or Valid
            if (nationalIdData['national_id_card_status'] == 'Expired') {
              setState(() {
                is_National_Id_Card_Expired = true;
              });
            }

            setState(() {
              hasNationalId = true;

              // You can also load other data into your controllers here
              _cardNumberController.text = nationalIdData['national_id_number'];
              _fullNameController.text = nationalIdData['fullname'];
              _birthDateController.text = nationalIdData['birthdate'];
              _genderController.text = nationalIdData['gender'];
              _issueDateController.text = nationalIdData['issued_date'];
              _expiryDateController.text = nationalIdData['Expire_Date'];
              _maritalStatusController.text = nationalIdData['martial_status'];
              National_Id_Card_Citizen_imagePath =
                  "${nationalIdData['citizen_image']}";
            });
          } else {
            setState(() {
              hasNationalId = false;
            });
            print("National ID not approved or invalid.");
          }
        } else {
          print("No national ID data found.");
          setState(() {
            hasNationalId = false;
          });
        }
      } else {
        throw Exception("Failed to load National ID data.");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> _loadBirthCertificateData() async {
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');

    try {
      var response = await http.get(
        Uri.parse(
          'http://192.168.100.10/egov_back/birth_certificate/$citizenId',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' &&
            data['birth_certificate_data'] != null &&
            data['birth_certificate_data'].isNotEmpty) {
          final birthCertificateData = data['birth_certificate_data'][0];

          // Check if the national_id_number is not "0" or empty
          if (isPassportId(birthCertificateData['scanned_birth_certificate'])) {
            // check if national id is Expired or Valid
            if (birthCertificateData['certificate_status'] == 'Expired') {
              setState(() {
                is_Certificate_Expired = true;
              });
            }

            if (birthCertificateData['citizen_image'] != null &&
                birthCertificateData['citizen_image'].toString().isNotEmpty) {
              _birthCertificateScannedImagePath =
                  birthCertificateData['scanned_birth_certificate'];
            } else {
              print("No image path found in passport data.");
            }

            setState(() {
              hasBirthCertificate = true;

              // You can also load other data into your controllers here
              _birthCertificate_fullname.text =
                  birthCertificateData['fullname'] ?? '';
              _birthCertificate_gender.text =
                  birthCertificateData['gender'] ?? '';
              _birthCertificate_state.text =
                  birthCertificateData['birthState'] ?? '';
              _birthCertificate_proffession.text =
                  birthCertificateData['Proffession'] ?? '';
              _birthCertificateScannedImagePath =
                  birthCertificateData['scanned_birth_certificate'] ?? '';
            });
          } else {
            setState(() {
              hasBirthCertificate = false;
            });
            print("Birth Certificate not approved or invalid.");
          }
        } else {
          print("No Passport data found.");
          setState(() {
            hasBirthCertificate = false;
          });
        }
      } else {
        throw Exception("Failed to load Birth Ceritificate data.");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> _loadPassportData() async {
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');

    try {
      var response = await http.get(
        Uri.parse('http://192.168.100.10/egov_back/passport_id/$citizenId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' &&
            data['passport_data'] != null &&
            data['passport_data'].isNotEmpty) {
          final passportData = data['passport_data'][0];

          print("Passport Data : $passportData");
          // Check if the national_id_number is not "0" or empty
          if (isPassportId(passportData['passport_number'])) {
            // check if national id is Expired or Valid
            if (passportData['passport_status'] == 'Expired') {
              setState(() {
                is_Passport_Expired = true;
              });
            }

            if (passportData['citizen_image'] != null &&
                passportData['citizen_image'].toString().isNotEmpty) {
              _passport_citizen_imagePath = passportData['citizen_image'];
            } else {
              print("No image path found in passport data.");
            }

            setState(() {
              hasPassportId = true;

              // You can also load other data into your controllers here
              _passport_citizen_fullname = passportData['fullname'] ?? '';
              _passport_citizen_gender = passportData['gender'] ?? '';
              _passport_birthState = passportData['birthState'] ?? '';
              _passport_birth_date = passportData['birthdate'] ?? '';
              _passport_Number = passportData['passport_number'] ?? '';
              _passport_issued_At = passportData['issued_At'] ?? '';
              _passport_expire_At = passportData['Expire_At'] ?? '';
              _passport_citizen_imagePath = passportData['citizen_image'] ?? '';
            });
          } else {
            setState(() {
              hasPassportId = false;
            });
            print("Passport not approved or invalid.");
          }
        } else {
          print("No Passport data found.");
          setState(() {
            hasPassportId = false;
          });
        }
      } else {
        throw Exception("Failed to load Passport data.");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> _loadBusinessCertificateData() async {
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');

    try {
      var response = await http.get(
        Uri.parse(
          'http://192.168.100.10/egov_back/business_certificate/$citizenId',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' &&
            data['business_certificate_data'] != null &&
            data['business_certificate_data'].isNotEmpty) {
          final businessCertificateData = data['business_certificate_data'][0];

          // Check if the national_id_number is not "0" or empty
          if (isPassportId(
            businessCertificateData['scanned_business_certificate'],
          )) {
            // check if national id is Expired or Valid
            if (businessCertificateData['business_status'] == 'Expired') {
              setState(() {
                is_Business_Expired = true;
              });
            }

            if (businessCertificateData['citizen_image'] != null &&
                businessCertificateData['citizen_image']
                    .toString()
                    .isNotEmpty) {
              _businessCertificateScannedImagePath =
                  businessCertificateData['scanned_business_certificate'];
            } else {
              print("No image path found in Business data.");
            }

            setState(() {
              hasBusinessCertificate = true;
              _business_requestStatus =
                  businessCertificateData['business_status'];

              _business_fullname.text = businessCertificateData['fullname'];
              _business_name.text = businessCertificateData['business_name'];
              _business_address.text =
                  businessCertificateData['business_Address'];
              _business_type.text = businessCertificateData['business_type'];
              _business_start_date.text = businessCertificateData['Start_Date'];
            });
          } else {
            setState(() {
              hasBusinessCertificate = false;
            });
            print("Business Certificate not approved or invalid.");
          }
        } else {
          print("No Business data found.");
          setState(() {
            hasBirthCertificate = false;
          });
        }
      } else {
        throw Exception("Failed to load Business Ceritificate data.");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

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
            // if (driver_License_Data['license_status'] == 'Expired') {
            //   setState(() {
            //     is_National_Id_Card_Expired = true;
            //   });
            // }

            _plateNumberController.text = driverLicenseData['plate_number'];
            _DriverLicense_issueDateController.text =
                driverLicenseData['issued_At'];
            _DriverLicense_expiryDateController.text =
                driverLicenseData['Expire_At'];
            _driverLicense_requestStatus = driverLicenseData['license_status'];
            Driver_citizen_image_path = driverLicenseData['citizen_image'];
            setState(() {
              hasDriverLicense = true;
            });
          } else {
            setState(() {
              hasDriverLicense = false;
            });
            print("Driver License not approved or invalid.");
          }
        } else {
          print("No Driver License data found.");
          setState(() {
            hasDriverLicense = false;
          });
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

  @override
  void initState() {
    super.initState();
    _loadServiceData();
    _loadNationalIdCardData();
    _loadPassportData();
    _loadBirthCertificateData();
    _loadBusinessCertificateData();
    _loadDriverLicenseData();

    // Set initial text values (replace with your data)
    _cardNumberController.text = '1234 5678 9012 3456';
    _issueDateController.text = '01/01/2023';
    _expiryDateController.text = '12/31/2028';
    _fullNameController.text = 'John Doe';
    _birthDateController.text = '05/15/1990';
    _genderController.text = 'Male';
    _maritalStatusController.text = 'Single';
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

  bool isValidNationalId(String? id) {
    return id != null && id != '0' && id.trim().isNotEmpty;
  }

  bool isDriverPlateNumberValid(String? id) {
    return id != null && id != '0' && id.trim().isNotEmpty;
  }

  bool isPassportId(String? id) {
    return id != null && id != '0' && id.trim().isNotEmpty;
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
                citizen_image_path: National_Id_Card_Citizen_imagePath,
                is_National_Id_Card_Expired: is_National_Id_Card_Expired,
              ), // Centered RequestCard widget
            ],

            if (widget.service.serId == 2) ...[
              Passport(
                hasPassport: hasPassportId,
                requestStatus: RequesStatus,
                Questions: Questions,
                Answers: Answers,
                passport_citizen_image_path: _passport_citizen_imagePath,
                is_passport_Expired: is_Passport_Expired,
                fullname: _passport_citizen_fullname,
                gender: _passport_citizen_gender,
                birthState: _passport_birthState,
                birthdate: _passport_birth_date,
                issuedDate: _passport_issued_At,
                expireDate: _passport_expire_At,
                passport_number: _passport_Number,
              ),
            ],

            if (widget.service.serId == 3) ...[
              BirthCertificate(
                hasBirthCertificate: hasBirthCertificate,
                birthcertificate_requestStatus: RequesStatus,
                birthcertificate_Questions: birthcertificate_Questions,
                birthcertificate_Answers: birthcertificate_Answers,
                birthCertificate_fullname: _birthCertificate_fullname,
                birthCertificate_gender: _birthCertificate_gender,
                birthCertificate_state: _birthCertificate_state,
                birthCertificate_proffession: _birthCertificate_proffession,
                birthCertificateScannedImagePath:
                    _birthCertificateScannedImagePath,
                isBirthCertificateExpired: is_Certificate_Expired,
              ),
            ],

            if (widget.service.serId == 4) ...[
              Business(
                hasBusiness: hasBusinessCertificate,
                Business_requestStatus: _business_requestStatus,
                BusinessQuestions: BusinessQuestions,
                BusinessAnswers: BusinessAnswers,
                business_fullname: _business_fullname,
                business_name: _business_name,
                business_address: _business_address,
                business_type: _business_type,
                business_start_Date: _business_start_date,
              ),
            ],

            if (widget.service.serId == 5) ...[
              DrivingLicense(
                cardNumberController: _plateNumberController,
                issueDateController: _DriverLicense_issueDateController,
                expiryDateController: _DriverLicense_issueDateController,

                fullNameController: _fullNameController,
                birthDateController: _birthDateController,
                genderController: _genderController,
                maritalStatusController: _maritalStatusController,
                hasDrivingLicense: hasDriverLicense,
                DriverLicenseQuestions: driverLicenseQuestions,
                DriverLicenseAnswers: driverLicenseAnswers,
                driverLicense_requestStatus: _driverLicense_requestStatus,
                Driver_citizen_image_path: _driver_Citizen_imagePath,
                plateNumberController: _plateNumberController,
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
  final String citizen_image_path;
  final bool is_National_Id_Card_Expired;

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
    required this.citizen_image_path,
    required this.is_National_Id_Card_Expired,
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
          image_path: citizen_image_path,
          is_National_Id_Card_Expired: is_National_Id_Card_Expired,
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
  final String image_path;
  final bool is_National_Id_Card_Expired;
  const PageContent({
    super.key,
    required this.cardNumberController,
    required this.issueDateController,
    required this.expiryDateController,
    required this.fullNameController,
    required this.birthDateController,
    required this.genderController,
    required this.maritalStatusController,
    required this.image_path,
    required this.is_National_Id_Card_Expired,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        National_ID_CARD_STRUCTURE(
          Citizen_ID_Image: image_path,
          is_National_Id_Card_Expired: is_National_Id_Card_Expired,
        ),
        SizedBox(height: 40),
        Card_Details(
          cardNumberController: cardNumberController,
          issueDateController: issueDateController,
          expiryDateController: expiryDateController,
          fullNameController: fullNameController,
          birthDateController: birthDateController,
          genderController: genderController,
          maritalStatusController: maritalStatusController,
          is_National_Id_Card_Expired: is_National_Id_Card_Expired,
        ),
      ],
    );
  }
}

// components

class National_ID_CARD_STRUCTURE extends StatelessWidget {
  final String Citizen_ID_Image;
  final bool is_National_Id_Card_Expired;
  const National_ID_CARD_STRUCTURE({
    super.key,
    required this.Citizen_ID_Image,
    required this.is_National_Id_Card_Expired,
  });

  @override
  Widget build(BuildContext context) {
    print("The Citizen image is: $Citizen_ID_Image");
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
                  image: DecorationImage(
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

              is_National_Id_Card_Expired
                  ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      // width: 100,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          "Expired",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                  : SizedBox(),
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
                  image: DecorationImage(
                    image: NetworkImage(
                      "http://192.168.100.10/egov_back/$Citizen_ID_Image",
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
  final bool is_National_Id_Card_Expired;
  const Card_Details({
    super.key,
    required this.cardNumberController,
    required this.issueDateController,
    required this.expiryDateController,
    required this.fullNameController,
    required this.birthDateController,
    required this.genderController,
    required this.maritalStatusController,
    required this.is_National_Id_Card_Expired,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Card-Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            is_National_Id_Card_Expired
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    // width: 100,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "Renewal",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
                : SizedBox(),
          ],
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

  final String passport_citizen_image_path;
  final bool is_passport_Expired;

  final String fullname;
  final String gender;
  final String birthState;
  final String birthdate;
  final String issuedDate;
  final String expireDate;
  final String passport_number;

  const Passport({
    super.key,
    required this.hasPassport,
    required this.requestStatus,
    required this.Questions,
    required this.Answers,
    required this.passport_citizen_image_path,
    required this.is_passport_Expired,
    required this.fullname,
    required this.gender,
    required this.birthState,
    required this.birthdate,
    required this.issuedDate,
    required this.expireDate,
    required this.passport_number,
  });

  @override
  Widget build(BuildContext context) {
    if (hasPassport) {
      // check the request status
      if (requestStatus == 'Approved') {
        return is_passport_Expired
            ? Column(
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
                      onPressed: () {
                        // Navigator.pushNamed(context, 'passport_form');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "Renew Passport",
                        style: TextStyle(fontSize: 16),
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
            )
            : PassportPage(
              passport_citizen_image_path: passport_citizen_image_path,
              fullname: fullname,
              gender: gender,
              birthState: birthState,
              birthdate: birthdate,
              issuedDate: issuedDate,
              expireDate: expireDate,
              passport_number: passport_number,
            );
      } else {
        // if it is requested
        if (requestStatus == 'Requested') {
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.redAccent, // Background color (primary blue)
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
                      "Your Passport is Getting Ready ..... ",
                      style: TextStyle(
                        fontSize: 16,
                      ), // Optional: Adjust text size
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text(
              "Your Passport Has Been Declined For Security Issues Contact The Support Team Via Help Center !",
              style: TextStyle(
                fontSize: 26,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        // if it is decline
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
  final String birthCertificateScannedImagePath;
  final bool isBirthCertificateExpired;

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
    required this.birthCertificateScannedImagePath,
    required this.isBirthCertificateExpired,
  });

  @override
  Widget build(BuildContext context) {
    if (hasBirthCertificate) {
      // check the request status
      if (birthcertificate_requestStatus == 'Approved') {
        return isBirthCertificateExpired
            ? Column(
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

                SizedBox(height: 5),
                Center(
                  child: Text(
                    "Your Old Birth Certificate is Expired",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                        backgroundColor:
                            Colors.redAccent, // Background color (primary blue)
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
                        "Request New Birth Certificate",
                        style: TextStyle(
                          fontSize: 16,
                        ), // Optional: Adjust text size
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
            )
            : BirthCertificate_Details(
              birthCertificate_fullname: birthCertificate_fullname,
              birthCertificate_gender: birthCertificate_gender,
              birthCertificate_state: birthCertificate_state,
              birthCertificate_proffession: birthCertificate_proffession,
              birthCertificateScannedImagePath:
                  birthCertificateScannedImagePath,
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
  final String birthCertificateScannedImagePath;
  const BirthCertificate_Details({
    super.key,
    required this.birthCertificate_fullname,
    required this.birthCertificate_gender,
    required this.birthCertificate_state,
    required this.birthCertificate_proffession,
    required this.birthCertificateScannedImagePath,
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

  final TextEditingController business_address;
  final TextEditingController business_type;
  final TextEditingController business_start_Date;

  const Business({
    super.key,
    required this.hasBusiness,
    required this.Business_requestStatus,
    required this.BusinessQuestions,
    required this.BusinessAnswers,
    required this.business_fullname,
    required this.business_name,
    required this.business_address,
    required this.business_type,
    required this.business_start_Date,
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
          business_address: business_address,
          business_type: business_type,
          business_start_Date: business_start_Date,
        );
      } else {
        if (Business_requestStatus == "Requested") {
          return CertificateWaitingWidget(certificateType: 'Business');
        } else if (Business_requestStatus == "Expired") {
          return CertificateDeclinedWidget(
            reason: "Due To Valid Documents",
            certificateType: '',
            onResubmit: () {
              Navigator.pushNamed(context, 'business_form');
            },
          );
        }
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

  final TextEditingController business_address;
  final TextEditingController business_type;
  final TextEditingController business_start_Date;

  const BusinessDetails({
    super.key,
    required this.business_fullname,
    required this.business_name,
    required this.business_address,
    required this.business_type,
    required this.business_start_Date,
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
          const SizedBox(height: 16),
          _buildTextField(
            controller: business_address,
            icon: FontAwesomeIcons.addressBook,
            label: 'Business Address',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: business_type,
            icon: FontAwesomeIcons.typo3,
            label: 'Business Type',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: business_start_Date,
            icon: FontAwesomeIcons.calendar,
            label: 'Business Start Date',
          ),
        ],
      ),
    );
  }
}

class CertificateWaitingWidget extends StatelessWidget {
  final String
  certificateType; // e.g., "Business", "Driver License", "Birth Certificate"

  const CertificateWaitingWidget({super.key, required this.certificateType});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange[100],
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_empty, size: 60, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Waiting for $certificateType Certificate Approval',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your $certificateType certificate application is under review. You will be notified once it is approved.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CertificateDeclinedWidget extends StatelessWidget {
  final String certificateType;
  final String reason;
  final VoidCallback onResubmit; // Generic callback function

  const CertificateDeclinedWidget({
    super.key,
    required this.certificateType,
    required this.reason,
    required this.onResubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[100],
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cancel, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '$certificateType Certificate Declined',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('Reason: $reason', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            const Text(
              'Please review the reason and resubmit your application.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onResubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Resubmit $certificateType Certificate",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
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

  final TextEditingController cardNumberController;
  final TextEditingController issueDateController;
  final TextEditingController expiryDateController;
  final TextEditingController fullNameController;
  final TextEditingController birthDateController;
  final TextEditingController genderController;
  final TextEditingController maritalStatusController;
  final String Driver_citizen_image_path;
  final TextEditingController plateNumberController;

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
    required this.Driver_citizen_image_path,
    required this.plateNumberController,
  });

  @override
  Widget build(BuildContext context) {
    if (hasDrivingLicense) {
      // check the request status
      if (driverLicense_requestStatus == 'Approved') {
        return Column(
          children: [
            DriverLicenseIDStructure(
              Driver_citizen_image_path: Driver_citizen_image_path,
              plateNumber: plateNumberController.text,
              Fullname: fullNameController.text,
              Gender: genderController.text,
              DOB: birthDateController.text,
              issued_At: issueDateController.text,
              Expire_At: expiryDateController.text,
            ),
            DriverLicenseDetails(
              cardNumberController: plateNumberController,
              issueDateController: issueDateController,
              expiryDateController: expiryDateController,
              fullNameController: fullNameController,
              birthDateController: birthDateController,
              genderController: genderController,
              maritalStatusController: maritalStatusController,
              ExpireDateController: expiryDateController,
            ),
          ],
        );
      } else {
        if (driverLicense_requestStatus == "Requested") {
          return CertificateWaitingWidget(certificateType: 'Driver License');
        } else {
          return CertificateDeclinedWidget(
            reason: "Due To Road Validation",
            certificateType: 'Driver License',
            onResubmit: () {
              Navigator.pushNamed(context, 'driver_License_form');
            },
          );
        }
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
  final String Driver_citizen_image_path;

  final String plateNumber;
  final String Fullname;
  final String Gender;
  final String DOB;
  final String issued_At;
  final String Expire_At;

  const DriverLicenseIDStructure({
    super.key,
    required this.Driver_citizen_image_path,
    required this.plateNumber,
    required this.Fullname,
    required this.Gender,
    required this.DOB,
    required this.issued_At,
    required this.Expire_At,
  });

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
                        _buildInfoItem("Identity No:", plateNumber),
                        _buildInfoItem("Full Name:", Fullname),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Gender and Birthdate Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem("Gender:", Gender),
                        _buildInfoItem("DOB:", DOB),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Issue/Expiry Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem("Issued:", issued_At),
                        _buildInfoItem("Expires:", Expire_At),
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
                  image: DecorationImage(
                    // image: AssetImage("assets/images/person.jpg"),
                    image: NetworkImage(
                      "http://192.168.100.10/egov_back/$Driver_citizen_image_path",
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

class DriverLicenseDetails extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController issueDateController;
  final TextEditingController ExpireDateController;
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
    required this.ExpireDateController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "License - Details",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Divider(),
        _buildTextField(
          controller: cardNumberController,
          icon: Icons.credit_card,
          label: 'Plate Number',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: issueDateController,
          icon: Icons.calendar_today,
          label: 'Date of Issue',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: ExpireDateController,
          icon: Icons.calendar_today,
          label: 'Date of Expire',
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
