import 'package:flutter/material.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/banner_img_2.jpeg"),
            fit: BoxFit.cover,
          ),

          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        // child:,
      ),
    );
  }
}
