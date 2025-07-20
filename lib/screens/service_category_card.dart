import 'package:flutter/material.dart';

class ServiceCategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String assetImagePath;
  final VoidCallback? onTap;

  const ServiceCategoryCard({
    Key? key,
    required this.title,
    required this.description,
    required this.assetImagePath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  assetImagePath,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
