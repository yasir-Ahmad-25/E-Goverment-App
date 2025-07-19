import 'package:e_govermenet/components/common/certificate_status_widgets.dart';
import 'package:e_govermenet/components/common/faq_section_widget.dart';
import 'package:e_govermenet/components/models/service_specific_data.dart';
import 'package:e_govermenet/components/services/api_constants.dart';
import 'package:flutter/material.dart';

class PassportSection extends StatelessWidget {
  final PassportData? data;
  final List<String> questions; // Pass these from the screen or constants
  final List<String> answers;

  const PassportSection({
    super.key,
    required this.data,
    required this.questions,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    // Handle loading state if data is null but expected based on an initial check
    // For this example, assuming data can be null if not yet fetched or doesn't exist.

    if (data == null || data!.requestStatus == "NEW") {
      return _buildRequestPassportUI(context);
    }

    if (data!.requestStatus == "Requested" ||
        data!.requestStatus == "Pending") {
      return CertificateWaitingWidget(certificateType: "Passport");
    }

    if (data!.requestStatus == "Declined") {
      return CertificateDeclinedWidget(
        certificateType: "Passport",
        reason:
            "Please check details or contact support.", // Replace with actual reason if available
        onResubmit: () {
          Navigator.pushNamed(
            context,
            'passport_form',
          ); // Ensure this route exists
        },
      );
    }

    if (data!.requestStatus == "Approved") {
      if (data!.isExpired) {
        return _buildRenewPassportUI(context);
      } else {
        print("passport image: ${data!.citizenImagePath}");
        // Use your existing PassportPage or the placeholder
        return PassportPagePlaceholder(
          passportCitizenImagePath: data!.citizenImagePath,
          fullname: data!.fullName,
          gender: data!.gender,
          birthState: data!.birthState,
          birthdate: data!.birthDate,
          issuedDate: data!.issuedAt,
          expireDate: data!.expireAt,
          passportNumber: data!.passportNumber,
        );
      }
    }

    return _buildRequestPassportUI(context); // Fallback
  }

  Widget _buildRequestPassportUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // You can use a generic image banner component here
          Center(
            child: Image.asset(
              "assets/images/passport.jpg",
              height: 200,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "A passport is your gateway to global travel and identity verification. Apply today to access international opportunities with ease.",
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
                  'passport_form',
                ); // Ensure this route exists
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Request Passport"),
            ),
          ),
          FaqSectionWidget(questions: questions, answers: answers),
        ],
      ),
    );
  }

  Widget _buildRenewPassportUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              "assets/images/passport.jpg",
              height: 200,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Your passport has expired or is about to expire. Renew it to continue your international travels.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.orange[700]),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to Passport renewal form
                Navigator.pushNamed(context, 'passport_form'); // Example route
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Navigate to Passport Renewal"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Renew Passport"),
            ),
          ),
          FaqSectionWidget(questions: questions, answers: answers),
        ],
      ),
    );
  }
}

class PassportPagePlaceholder extends StatelessWidget {
  final String passportCitizenImagePath;
  final String fullname;
  final String gender;
  final String birthState;
  final String birthdate;
  final String issuedDate;
  final String expireDate;
  final String passportNumber;

  const PassportPagePlaceholder({
    super.key,
    required this.passportCitizenImagePath,
    required this.fullname,
    required this.gender,
    required this.birthState,
    required this.birthdate,
    required this.issuedDate,
    required this.expireDate,
    required this.passportNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(14),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Color(0xfff8f9fa),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.13),
              spreadRadius: 2,
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: country name and passport image
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Country Name (small)
                Expanded(
                  child: Text(
                    "Federal Republic of Somalia",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Colors.blueGrey[700],
                      letterSpacing: 1,
                    ),
                  ),
                ),
                // Right: Passport emblem/image (smaller)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/somalia_passport.jpg',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // PASSPORT title
            Text(
              "PASSPORT",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.indigo,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 24),
            // Main Row: photo and info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Citizen photo
                Container(
                  width: 110,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue.shade200, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.07),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: passportCitizenImagePath.isNotEmpty
                          ? NetworkImage(ApiConstants.getImageUrl(passportCitizenImagePath))
                          : AssetImage('assets/images/person.jpg') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 28),
                // Info Table
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _passportInfo("Full Name", fullname),
                      _passportInfo("Gender", gender),
                      if (birthState.isNotEmpty) _passportInfo("Birth State", birthState),
                      _passportInfo("Birth Date", birthdate),
                      _passportInfo("Passport No.", passportNumber),
                      _passportInfo("Issued At", issuedDate == "0000-00-00" ? "N/A" : issuedDate),
                      _passportInfo("Expiry Date", expireDate),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Footer: status & note
            Row(
              children: [
                Icon(Icons.verified_user_rounded, color: Colors.green, size: 24),
                SizedBox(width: 8),
                Text(
                  "Status: Approved",
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  "Somali eGov",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _passportInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 115,
            child: Text(
              "$label:",
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "-",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildDataRow(String value, String label) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        value,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(label, style: TextStyle(color: Colors.black, fontSize: 14)),
    ],
  );
}

