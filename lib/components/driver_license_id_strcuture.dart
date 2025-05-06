import 'package:flutter/material.dart';

class DriverLicenseIDStructure extends StatelessWidget {
  final String Driver_citizen_image_path;

  final String plateNumber;
  final String Fullname;
  final String Gender;
  final String DOB;
  final String issued_At;
  final String Expire_At;

  const DriverLicenseIDStructure({
    super.key,
    required this.Driver_citizen_image_path,
    required this.plateNumber,
    required this.Fullname,
    required this.Gender,
    required this.DOB,
    required this.issued_At,
    required this.Expire_At,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 230, // Increased height
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
          // Top Section with Flag and Country Names
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://www.ecss-online.com/2013/wp-content/uploads/2022/12/somalia.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: const [
                  Text(
                    "Jamhuuriyada Federalka Somalia",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "جمهورية الصومال الفيدرالية",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Federal Republic of Somalia",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          const Divider(thickness: 1, color: Colors.grey),

          // Content Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Content Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Identity and Name Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem("Identity No:", plateNumber),
                        _buildInfoItem("Full Name:", Fullname),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Gender and Birthdate Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem("Gender:", Gender),
                        _buildInfoItem("DOB:", DOB),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Issue/Expiry Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem("Issued:", issued_At),
                        _buildInfoItem("Expires:", Expire_At),
                      ],
                    ),
                  ],
                ),
              ),

              // Profile Image
              Container(
                margin: const EdgeInsets.only(left: 16),
                width: 100,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    // image: AssetImage("assets/images/person.jpg"),
                    image: NetworkImage(
                      "http://192.168.100.10/egov_back/$Driver_citizen_image_path",
                    ),
                    fit: BoxFit.cover,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
