import 'package:e_govermenet/service_info.dart';
import 'package:flutter/material.dart';
import 'service_category_card.dart'; // Import your card widget

class ServiceSectionedList extends StatelessWidget {
  final Map<String, List<ServiceInfo>> serviceSections;
  final void Function(ServiceInfo)? onServiceTap;

  const ServiceSectionedList({
    Key? key,
    required this.serviceSections,
    this.onServiceTap,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: serviceSections.entries.map((entry) {
          final section = entry.key;
          final services = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                section,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  color: Colors.teal[700],
                ),
              ),
              SizedBox(height: 8),
              ...services.map((service) => ServiceCategoryCard(
                title: service.title,
                description: service.description,
                assetImagePath: service.assetImagePath,
                onTap: () => onServiceTap?.call(service),
              )),
            ],
          );
        }).toList(),
      ),
    );
  }

}
