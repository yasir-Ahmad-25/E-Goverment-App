import 'package:e_govermenet/components/common/app_text_field.dart';
import 'package:e_govermenet/components/models/service_specific_data.dart';
import 'package:e_govermenet/components/services/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BusinessCertificateDetailsView extends StatefulWidget {
  final BusinessCertificateData data;

  const BusinessCertificateDetailsView({super.key, required this.data});

  @override
  State<BusinessCertificateDetailsView> createState() => _BusinessCertificateDetailsViewState();
}

class _BusinessCertificateDetailsViewState extends State<BusinessCertificateDetailsView> {
  late TextEditingController _ownerFullNameController;
  late TextEditingController _businessNameController;
  late TextEditingController _businessAddressController;
  late TextEditingController _businessTypeController;
  late TextEditingController _startDateController;

  @override
  void initState() {
    super.initState();
    _ownerFullNameController = TextEditingController(text: widget.data.fullName);
    _businessNameController = TextEditingController(text: widget.data.businessName);
    _businessAddressController = TextEditingController(text: widget.data.businessAddress);
    _businessTypeController = TextEditingController(text: widget.data.businessType);
    _startDateController = TextEditingController(text: widget.data.startDate);
  }

  @override
  void dispose() {
    _ownerFullNameController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _businessTypeController.dispose();
    _startDateController.dispose();
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
              const Text("Business Registration Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
               if (widget.data.isExpired) // Assuming 'isExpired' is set correctly
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text("Renew/Update"),
                  onPressed: () {
                    // TODO: Navigate to business registration update/renewal form
                     Navigator.pushNamed(context, 'business_form'); // Or a specific renewal form
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Navigate to Business Renewal/Update TBD"))
                    );
                  },
                   style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                )
            ],
          ),
          const Divider(),
          AppTextField(controller: _ownerFullNameController, label: 'Owner Full Name', icon: Icons.person_outline),
          const SizedBox(height: 16),
          AppTextField(controller: _businessNameController, label: 'Business Name', icon: FontAwesomeIcons.store),
          const SizedBox(height: 16),
          AppTextField(controller: _businessAddressController, label: 'Business Address', icon: FontAwesomeIcons.mapMarkerAlt),
          const SizedBox(height: 16),
          AppTextField(controller: _businessTypeController, label: 'Type of Business', icon: FontAwesomeIcons.tags),
          const SizedBox(height: 16),
          AppTextField(controller: _startDateController, label: 'Registration/Start Date', icon: FontAwesomeIcons.calendarCheck),
           const SizedBox(height: 20),
          if (widget.data.scannedCertificatePath.isNotEmpty) ...[
            const Text("Scanned Business Certificate:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Center(
              child: Image.network(
                ApiConstants.getImageUrl(widget.data.scannedCertificatePath),
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.red),
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null));
                },
              ),
            ),
          ] else ... [
            const Text("No scanned business certificate image available.", style: TextStyle(fontStyle: FontStyle.italic)),
          ]
        ],
      ),
    );
  }
}