import 'package:flutter/material.dart';
import 'package:e_govermenet/components/request_card.dart';
import 'package:e_govermenet/screens/home_screen.dart';

class ServiceDetailPage extends StatelessWidget {
  final GovService service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final bool hasNationalId = service.status == 'Active';

    return Scaffold(
      appBar: AppBar(title: Text(service.name), centerTitle: true),
      body: SingleChildScrollView(
        // for better UX on small screens
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Conditional block for National ID
            if (service.serId == 1) ...[
              if (service.status == "Active")
                Text(
                  "Congrats! You already have a National ID Card.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                Center(child: RequestCard()), // Centered RequestCard widget
            ] else ...[
              Text(
                "Description:",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                service.descriptions,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NationalIdCard extends StatelessWidget {
  final bool hasNationalId;

  const NationalIdCard({super.key, required this.hasNationalId});

  @override
  Widget build(BuildContext context) {
    if (hasNationalId) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Congrats!",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.green[700]),
          ),
          const SizedBox(height: 8),
          Text(
            "You already have a National ID Card.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "You don't have a National ID yet.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        Center(child: RequestCard()), // Centered RequestCard widget
      ],
    );
  }
}
