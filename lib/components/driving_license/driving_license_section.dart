// lib/components/driving_license/driving_license_section.dart
import 'package:e_govermenet/components/models/service_specific_data.dart';
import 'package:flutter/material.dart';
import '../common/request_card_placeholder.dart';
import '../common/faq_section_widget.dart';
import '../common/certificate_status_widgets.dart';
import 'driving_license_card_view.dart';
import 'driving_license_details_view.dart';

class DrivingLicenseSection extends StatelessWidget {
  final DriverLicenseData? data;
  final List<String> questions;
  final List<String> answers;
  // final Map<String, dynamic>? nationalIdProfile; // If needed separately

  const DrivingLicenseSection({
    super.key,
    required this.data,
    required this.questions,
    required this.answers,
    // this.nationalIdProfile,
  });

  @override
  Widget build(BuildContext context) {
    if (data == null || data!.requestStatus == "NEW") {
      return _buildRequestUI(context);
    }

    if (data!.requestStatus == "Requested" ||
        data!.requestStatus == "Pending") {
      return CertificateWaitingWidget(certificateType: "Driver's License");
    }

    if (data!.requestStatus == "Declined") {
      return CertificateDeclinedWidget(
        certificateType: "Driver's License",
        reason:
            "Application declined. Please check requirements or contact support.", // Specific reason if available
        onResubmit: () {
          Navigator.pushNamed(
            context,
            'driver_license_form',
          ); // Ensure route exists
        },
      );
    }

    if (data!.requestStatus == "Expired") {
      // Explicitly handle expired status from API
      return _buildExpiredUI(context);
    }

    if (data!.requestStatus == "Approved") {
      // The isExpired flag in DriverLicenseData should be set based on 'license_status' or date comparison
      if (data!.isExpired) {
        return _buildExpiredUI(context);
      }
      return Column(
        children: [
          DrivingLicenseCardView(
            citizenImagePath: data!.citizenImagePath,
            plateNumber: data!.plateNumber,
            fullName:
                data!
                    .fullName, // Sourced from National ID profile via ApiService
            gender: data!.gender,
            dob: data!.birthDate,
            issuedDate: data!.issuedAt,
            expiryDate: data!.expireAt,
            isExpired: data!.isExpired,
          ),
          DrivingLicenseDetailsView(data: data!),
        ],
      );
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
              "assets/images/driver_license.jpg",
              height: 200,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "A driver’s license is your official authorization to operate motor vehicles. Get yours today to drive legally, prove your identity, and access essential services with confidence.",
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
                  'driver_License_form',
                ); // Ensure route exists
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Request Driver's License"),
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
              "assets/images/driver_license.jpg",
              height: 200,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Your Driver's License has expired. Please renew it to continue driving legally.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.orange[700]),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to renewal form
                Navigator.pushNamed(context, 'driver_license_renewal_form');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Navigate to License Renewal TBD"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Renew Driver's License"),
            ),
          ),
          FaqSectionWidget(questions: questions, answers: answers),
          // Optionally, show the details of the expired license if 'data' is not null
          if (data != null &&
              (data!.requestStatus == "Approved" ||
                  data!.requestStatus == "Expired") &&
              data!.isExpired) ...[
            const SizedBox(height: 20),
            DrivingLicenseCardView(
              citizenImagePath: data!.citizenImagePath,
              plateNumber: data!.plateNumber,
              fullName: data!.fullName,
              gender: data!.gender,
              dob: data!.birthDate,
              issuedDate: data!.issuedAt,
              expiryDate: data!.expireAt,
              isExpired: data!.isExpired,
            ),
            DrivingLicenseDetailsView(data: data!),
          ],
        ],
      ),
    );
  }
}
