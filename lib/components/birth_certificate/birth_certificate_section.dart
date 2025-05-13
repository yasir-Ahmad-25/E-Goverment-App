import 'package:e_govermenet/components/birth_certificate/birth_certificate_details_view.dart';
import 'package:e_govermenet/components/common/certificate_status_widgets.dart';
import 'package:e_govermenet/components/common/faq_section_widget.dart';
import 'package:e_govermenet/components/models/service_specific_data.dart';
import 'package:flutter/material.dart';

class BirthCertificateSection extends StatelessWidget {
  final BirthCertificateData? data;
  final List<String> questions;
  final List<String> answers;

  const BirthCertificateSection({
    super.key,
    required this.data,
    required this.questions,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    if (data == null || data!.requestStatus == "NEW") {
      return _buildRequestUI(context);
    }

    if (data!.requestStatus == "Requested" || data!.requestStatus == "Pending") {
      return CertificateWaitingWidget(certificateType: "Birth Certificate");
    }

    if (data!.requestStatus == "Declined") {
      return CertificateDeclinedWidget(
        certificateType: "Birth Certificate",
        reason: "Application declined. Please review your details or contact support.", // Provide specific reason if available
        onResubmit: () {
          Navigator.pushNamed(context, 'birth_certificate_form'); // Ensure route exists
        },
      );
    }

    if (data!.requestStatus == "Approved") {
      if (data!.isExpired) { // Assuming 'isExpired' is correctly set in BirthCertificateData
        return _buildExpiredUI(context);
      } else {
        return BirthCertificateDetailsView(data: data!);
      }
    }
    
    return _buildRequestUI(context); // Fallback
  }

  Widget _buildRequestUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset("assets/images/birth_certificate.jpg", height: 200, fit: BoxFit.contain,
             errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100)),
          ),
          const SizedBox(height: 16),
          const Text(
            "A birth certificate is your official proof of identity and citizenship. Secure yours today to access essential services and legal rights with confidence.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'birth_certificate_form'); // Ensure route exists
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Request Birth Certificate"),
            ),
          ),
          FaqSectionWidget(questions: questions, answers: answers),
        ],
      ),
    );
  }

   Widget _buildExpiredUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Center(
            child: Image.asset("assets/images/birth_certificate.jpg", height: 200, fit: BoxFit.contain,
             errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100)),
          ),
          const SizedBox(height: 16),
          Text(
            "Your previously issued birth certificate might be considered expired or needs re-validation for current procedures. Please request a new one if required.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.orange[700]),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'birth_certificate_form'); // Route to request a new one
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Request New Birth Certificate"),
            ),
          ),
          FaqSectionWidget(questions: questions, answers: answers),
        ],
      ),
    );
  }
}