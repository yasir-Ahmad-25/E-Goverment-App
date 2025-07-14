import 'package:e_govermenet/components/birth_certificate/birth_certificate_section.dart';
import 'package:e_govermenet/components/business_certificate/business_certificate_section.dart';
import 'package:e_govermenet/components/common/error_display.dart';
import 'package:e_govermenet/components/common/loading_indicator.dart';
import 'package:e_govermenet/components/driving_license/driving_license_section.dart';
import 'package:e_govermenet/components/models/service_specific_data.dart';
import 'package:e_govermenet/components/national_id/national_id_section.dart';
import 'package:e_govermenet/components/passport/passport_section.dart';
import 'package:e_govermenet/components/services/api_service.dart';
import 'package:e_govermenet/screens/home_screen.dart';
import 'package:flutter/material.dart';

class PlaceholderSection extends StatelessWidget {
  final String title;
  const PlaceholderSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "$title section not yet implemented.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}

class ServiceDetailPage extends StatefulWidget {
  final GovService service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _loadDataFuture;

  // FAQ Data - ideally, this would come from a config or the service itself
  final Map<int, Map<String, List<String>>> _faqData = {
    1: {
      // National ID - No FAQ in original, add if needed
      'questions': [],
      'answers': [],
    },
    2: {
      // Passport
      'questions': [
        'What is a passport and why do I need one ?',
        'How do I apply for a passport ? ',
        'What documents are required to apply ? ',
        'How long does it take to receive my passport ? ',
        'Can I renew my passport before it expires ? ',
        'What should I do if my passport is lost or stolen ? ',
      ],
      'answers': [
        "A passport is an official travel document issued by a government...",
        "You can apply by clicking the “Request Passport” button...",
        "Typically, you’ll need a national ID, birth certificate...",
        "Processing time usually ranges from 2 to 6 weeks...",
        "Yes, it’s recommended to renew it 6 months before expiration...",
        "Report it immediately to the relevant authorities...",
      ],
    },
    3: {
      // Birth Certificate
      'questions': [
        'What is a birth certificate and why do I need one?',
        'How do I apply for a birth certificate?',
        // ... add all questions
      ],
      'answers': [
        "A birth certificate is an official document that records a person’s birth details...",
        "You can apply by clicking the “Request Birth Certificate” button...",
        // ... add all answers
      ],
    },
    4: {
      // Business Certificate
      'questions': [
        'What is business registration and why is it important?',
        // ... add all questions
      ],
      'answers': [
        "Business registration is the process of officially recording your business with the government...",
        // ... add all answers
      ],
    },
    5: {
      // Driver's License
      'questions': [
        'What is a driver’s license and why do I need one?',
        // ... add all questions
      ],
      'answers': [
        "A driver’s license is an official document issued by the government that permits you to operate a motor vehicle...",
        // ... add all answers
      ],
    },
    // Add FAQs for other services
  };

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _fetchAllServiceData();
  }

  Future<Map<String, dynamic>> _fetchAllServiceData() async {
    Map<String, dynamic> results = {};
    // Fetch common data or data needed by multiple sections first if any
    // Example: Fetch National ID profile which might be used by Driver's License
    final nationalIdProfile =
        await _apiService.fetchNationalIdProfileForOtherServices();
    results['nationalIdProfile'] = nationalIdProfile;

    try {
      switch (widget.service.serId) {
        case 1:
          results['nationalIdData'] = await _apiService.fetchNationalIdData();
          break;
        case 2:
          results['passportData'] = await _apiService.fetchPassportData();
          break;
        case 3:
          results['birthCertificateData'] =
              await _apiService.fetchBirthCertificateData();
          break;
        case 4:
          results['businessCertificateData'] =
              await _apiService.fetchBusinessCertificateData();
          break;
        case 5:
          results['driverLicenseData'] = await _apiService
              .fetchDriverLicenseData(nationalIdProfile);
          break;
        // Add cases for other services
        default:
          // Load general service status or nothing specific
          results['serviceStatus'] = await _apiService.getServiceStatus(
            widget.service.serId,
          );
      }
    } catch (e) {
      // Catch errors from specific fetches if not caught within ApiService
      // Or rely on FutureBuilder's error handling
      print("Error fetching data for service ${widget.service.serId}: $e");
      // results['error'] = e.toString(); // Store error to display it
    }
    return results;
  }

  void _retryLoadData() {
    setState(() {
      _loadDataFuture = _fetchAllServiceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.service.name), centerTitle: true),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }

          if (snapshot.hasError) {
            return ErrorDisplay(
              message: 'Failed to load service details: ${snapshot.error}',
              onRetry: _retryLoadData,
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return ErrorDisplay(
              message: 'No data available for this service.',
              onRetry: _retryLoadData,
            );
          }

          final data = snapshot.data!;

          print("the snapshot data: $data");
          // Determine which section to show
          Widget serviceContent;
          List<String> currentQuestions =
              _faqData[widget.service.serId]?['questions'] ?? [];
          List<String> currentAnswers =
              _faqData[widget.service.serId]?['answers'] ?? [];

          switch (widget.service.serId) {
            case 1:
              serviceContent = NationalIdSection(
                data: data['nationalIdData'] as NationalIdData?,
              );
              break;
            case 2:
              serviceContent = PassportSection(
                data: data['passportData'] as PassportData?,
                questions: currentQuestions,
                answers: currentAnswers,
              );
              break;
            case 3:
              serviceContent = BirthCertificateSection(
                data: data['birthCertificateData'] as BirthCertificateData?,
                questions: currentQuestions,
                answers: currentAnswers,
              );
              // serviceContent = PlaceholderSection(title: "Birth Certificate"); // Replace with actual
              break;
            case 4:
              serviceContent = BusinessCertificateSection(
                data:
                    data['businessCertificateData'] as BusinessCertificateData?,
                questions: currentQuestions,
                answers: currentAnswers,
              );
              // serviceContent = PlaceholderSection(
              //   title: "Business Certificate",
              // ); // Replace with actual
              break;
            case 5:
              serviceContent = DrivingLicenseSection(
                data: data['driverLicenseData'] as DriverLicenseData?,
                questions: currentQuestions,
                answers: currentAnswers,
                // You might need to pass the national ID profile here if not embedded in DriverLicenseData
                // nationalIdProfile: data['nationalIdProfile'],
              );
              // serviceContent = PlaceholderSection(
              //   title: "Driving License",
              // ); // Replace with actual
              break;
            case 6:
              // serviceContent = EducationCertificationSection(
              //   // Pass necessary data or controllers
              // );
              serviceContent = PlaceholderSection(
                title: "Education Certification",
              ); // Replace with actual
              break;
            default:
              serviceContent = const Center(
                child: Text('Service not implemented.'),
              );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: serviceContent,
          );
        },
      ),
    );
  }
}
