import 'package:e_govermenet/components/common/certificate_status_widgets.dart';
import 'package:e_govermenet/components/common/faq_section_widget.dart';
import 'package:e_govermenet/components/models/service_specific_data.dart';
import 'package:e_govermenet/screens/service_detailed_page.dart';
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

    print("the returned data is: $data");
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
                    content: Text("Navigate to Passport Renewal TBD"),
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
    // return Card(
    //   child: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           "Passport Details (Placeholder)",
    //           style: Theme.of(context).textTheme.headlineSmall,
    //         ),
    //         const SizedBox(height: 10),
    //         Text("Number: $passportNumber"),
    //         Text("Name: $fullname"),
    //         Text("Expires: $expireDate"),
    //         // Add more details and proper UI
    //         const SizedBox(height: 10),
    //         passportCitizenImagePath.isNotEmpty
    //             ? Image.network(
    //               passportCitizenImagePath,
    //               height: 100,
    //               errorBuilder: (c, o, s) => Icon(Icons.image_not_supported),
    //             )
    //             : const Text("No image"),
    //       ],
    //     ),
    //   ),
    // );

    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Text(
                  'FEDERAL REPUBLIC OF SOMALIA',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dynamic Photo
                  Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        image: passportCitizenImagePath != null
                            ? NetworkImage(passportCitizenImagePath)
                            : AssetImage('assets/images/person.jpg') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Passport image (could be static or dynamic)
                  Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        image: AssetImage('assets/images/somalia_passport.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              _buildDataRow('FULL NAME', fullname ?? ''),
              Divider(),
              // _buildDataRow('TYPE', type ?? ''),
              // Divider(),
              _buildDataRow('Gender', gender ?? ''),
              Divider(),
              // _buildDataRow('State', state ?? ''),
              // Divider(),
              // _buildDataRow('Birth Date', birthDate ?? ''),
              // Divider(),
              _buildDataRow('Passport NUMBER', passportNumber ?? ''),
            ],
          ),
        ),
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

