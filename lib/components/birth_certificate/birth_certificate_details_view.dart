import 'package:e_govermenet/components/common/app_text_field.dart';
import 'package:e_govermenet/components/models/service_specific_data.dart';
import 'package:e_govermenet/components/services/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BirthCertificateDetailsView extends StatefulWidget {
  final BirthCertificateData data;

  const BirthCertificateDetailsView({super.key, required this.data});

  @override
  State<BirthCertificateDetailsView> createState() => _BirthCertificateDetailsViewState();
}

class _BirthCertificateDetailsViewState extends State<BirthCertificateDetailsView> {
  late TextEditingController _fullNameController;
  late TextEditingController _genderController;
  late TextEditingController _birthStateController;
  late TextEditingController _professionController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.data.fullName);
    _genderController = TextEditingController(text: widget.data.gender);
    _birthStateController = TextEditingController(text: widget.data.birthState);
    _professionController = TextEditingController(text: widget.data.profession);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _genderController.dispose();
    _birthStateController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Birth Certificate Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (widget.data.isExpired)
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text("Request New"),
                  onPressed: () {
                    // TODO: Navigate to birth certificate application form
                    Navigator.pushNamed(context, 'birth_certificate_form');
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Navigate to Birth Certificate form TBD"))
                    );
                  },
                   style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                )
            ],
          ),
          const Divider(),
          AppTextField(controller: _fullNameController, label: 'Full Name', icon: Icons.person),
          const SizedBox(height: 16),
          AppTextField(controller: _genderController, label: 'Gender', icon: FontAwesomeIcons.venusMars),
          const SizedBox(height: 16),
          AppTextField(controller: _birthStateController, label: 'Place of Birth (State/Region)', icon: Icons.place),
          const SizedBox(height: 16),
          AppTextField(controller: _professionController, label: 'Profession', icon: FontAwesomeIcons.briefcase),
          const SizedBox(height: 20),
          if (widget.data.scannedCertificatePath.isNotEmpty) ...[
            const Text("Scanned Certificate:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Center(
              child: Image.network(
                ApiConstants.getImageUrl(widget.data.scannedCertificatePath),
                height: 200, // Adjust as needed
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 40),
                      Text("Could not load certificate image.", textAlign: TextAlign.center),
                    ],
                  );
                },
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
          ] else ... [
            const Text("No scanned certificate image available.", style: TextStyle(fontStyle: FontStyle.italic)),
          ]
        ],
      ),
    );
  }
}