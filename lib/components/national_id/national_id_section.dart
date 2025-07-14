import 'package:e_govermenet/components/models/service_specific_data.dart';
import 'package:e_govermenet/components/national_id/national_id_card_view.dart';
import 'package:e_govermenet/components/national_id/national_id_details_view.dart';
import 'package:e_govermenet/components/request_card.dart';
import 'package:flutter/material.dart';

class NationalIdSection extends StatelessWidget {
  final NationalIdData? data;
  // final String requestStatus; // This will now come from NationalIdData

  const NationalIdSection({
    super.key,
    required this.data,
    // required this.requestStatus,
  });

  @override
  Widget build(BuildContext context) {
    
    print("fetched data is: ${data}");

    if (data == null || data!.requestStatus == "NEW") {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: RequestCard(
            // Replace with your actual RequestCard
            card_title: 'Request National ID Card',
            card_text: 'Muwaadin Hada Dalbo National Id Card.',
            showRequestButton: true,
          ),
        ),
      );
    }

    if (data!.requestStatus == "Requested" ||
        data!.requestStatus == "Pending") {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          child: RequestCard(
            // Replace with your actual RequestCard
            card_title: 'Application Pending',
            card_text:
                'Your National ID card application is being processed. Fadlan Sug.',
            showRequestButton: false,
          ),
        ),
      );
    }

    if (data!.requestStatus == "Declined") {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: RequestCard(
            // Replace with your actual RequestCard
            card_title: 'Application Declined',
            card_text:
                'Your National ID application was declined. Please contact support.',
            showRequestButton: false, // Or a button to see details/reapply
          ),
        ),
      );
    }

    if (data!.requestStatus == "Approved") {
      return Column(
        children: [
          NationalIdCardView(
            citizenImagePath: data!.citizenImagePath,
            isExpired: data!.isExpired,
            identityNumber: data!.cardNumber,
            fullName: data!.fullName,
            gender: data!.gender,
            dob: data!.birthDate,
            issuedDate: data!.issueDate,
            expiryDate: data!.expiryDate,
          ),
          NationalIdDetailsView(data: data!),
        ],
      );
    }

    // Fallback for any other unhandled status
    return Center(
      child: Text("Unknown status for National ID: ${data!.requestStatus}"),
    );
  }
}
