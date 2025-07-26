import 'package:e_govermenet/components/business_certificate/business_certificate_details_view.dart';
import 'package:e_govermenet/components/common/certificate_status_widgets.dart';
import 'package:e_govermenet/components/common/faq_section_widget.dart';
import 'package:e_govermenet/components/models/service_specific_data.dart';
import 'package:flutter/material.dart';

class BusinessCertificateSection extends StatelessWidget {
  final BusinessCertificateData? data;
  final List<String> questions;
  final List<String> answers;

  const BusinessCertificateSection({
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

    if (data!.requestStatus == "Requested" ||
        data!.requestStatus == "Pending") {
      return CertificateWaitingWidget(certificateType: "Business Registration");
    }

    if (data!.requestStatus == "Declined") {
      return CertificateDeclinedWidget(
        certificateType: "Business Registration",
        reason:
            "Application declined. Please review your details or contact support.",
        onResubmit: () {
          Navigator.pushNamed(context, 'business_form'); // Ensure route exists
        },
      );
    }

    if (data!.requestStatus == "Expired") {
      // Explicitly handle expired status from API
      return _buildExpiredUI(context);
    }

    if (data!.requestStatus == "Approved") {
      // If there's a separate 'isExpired' flag based on dates, you can check it here too.
      // For now, assuming 'Expired' status from API means it needs renewal.
      if (data!.isExpired) {
        // This flag should be set based on business_status or date comparison
        return _buildExpiredUI(context);
      }
      return BusinessCertificateDetailsView(data: data!);
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
            child: Image.asset(
              "assets/images/business.jpg",
              height: 200,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "A business registration is your official recognition by the government to legally operate. Register today to comply with regulations, build trust, and unlock business opportunities with confidence.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  'business_form',
                ); // Ensure route exists
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Register Business"),
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
            child: Image.asset(
              "assets/images/business.jpg",
              height: 200,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Your business registration has expired or needs renewal. Please update your registration to continue operating legally.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.orange[700]),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to renewal/update form
                Navigator.pushNamed(
                  context,
                  'business_renewal_form',
                ); // Or 'business_form' if it handles updates
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Navigate to Business Renewal TBD"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Renew/Update Registration"),
            ),
          ),
          FaqSectionWidget(questions: questions, answers: answers),
          if (data != null &&
              data!.requestStatus == "Approved" &&
              data!.isExpired) // Show current (expired) details if available
            BusinessCertificateDetailsView(data: data!),
        ],
      ),
    );
  }
}
