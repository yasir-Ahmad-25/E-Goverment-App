import 'package:e_govermenet/components/services/api_constants.dart';
import 'package:flutter/material.dart';

class NationalIdCardView extends StatelessWidget {
  final String citizenImagePath;
  final bool isExpired;
  // Add other details if they are directly on the card visual
  final String identityNumber;
  final String fullName;
  final String gender;
  final String dob;
  final String issuedDate;
  final String expiryDate;


  const NationalIdCardView({
    super.key,
    required this.citizenImagePath,
    required this.isExpired,
    required this.identityNumber,
    required this.fullName,
    required this.gender,
    required this.dob,
    required this.issuedDate,
    required this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 230, // Consider making height dynamic or use AspectRatio
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50, // Adjusted size
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage( // Replace with your actual flag URL or asset
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Flag_of_Somalia.svg/125px-Flag_of_Somalia.svg.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Jamhuuriyada Federalka Somalia", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    Text("جمهورية الصومال الفيدرالية", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    Text("Federal Republic of Somalia", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ],
                ),
              ),
              if (isExpired)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("Expired", style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
            ],
          ),
          const Divider(thickness: 1, color: Colors.grey, height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoItem("Identity No:", identityNumber),
                    _buildInfoItem("Full Name:", fullName),
                    _buildInfoItem("Gender:", gender),
                    _buildInfoItem("DOB:", dob),
                    _buildInfoItem("Issued:", issuedDate),
                    _buildInfoItem("Expires:", expiryDate),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: AspectRatio(
                  aspectRatio: 3/4, // Common ID photo aspect ratio
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: citizenImagePath.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(ApiConstants.getImageUrl(citizenImagePath)),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) => const Icon(Icons.person, size: 50),
                            )
                          : null,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: citizenImagePath.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}