import 'package:flutter/material.dart';

class PassportPage extends StatelessWidget {
  final String passport_citizen_image_path;
  final String fullname;
  final String gender;
  final String birthState;
  final String birthdate;
  final String issuedDate;
  final String expireDate;
  final String passport_number;
  const PassportPage({
    super.key,
    required this.passport_citizen_image_path,
    required this.fullname,
    required this.gender,
    required this.birthState,
    required this.birthdate,
    required this.issuedDate,
    required this.expireDate,
    required this.passport_number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4), // Add margin for shadow visibility
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
              // Country Information
              Center(
                child: Text(
                  'FEDERAL REPUBLIC OF SOMALIA',
                  style: TextStyle(
                    color: Colors.black, // Changed to black
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Passport Photo Section
                  Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        image: NetworkImage(
                          "http://192.168.100.10/egov_back/$passport_citizen_image_path",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Passport Section
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

              // Data Rows
              _buildDataRow('FULL NAME', fullname),
              Divider(),
              _buildDataRow('TYPE', 'Civilian Passport'),
              Divider(),
              // _buildDataRow('IGN', 'NATIONALITY'),
              _buildDataRow('Gender', gender),
              Divider(),
              _buildDataRow('State', birthState),
              Divider(),
              _buildDataRow('Birth Date', birthdate),
              Divider(),
              // _buildDataRow('JAKARTA', 'DNT CIP ISSUE'),
              // _buildDataRow('13 FEB 2023', 'DNT CEMPIRO'),
              // _buildDataRow('12 FEB 2023', 'ISSUE GIFICE'),
              // _buildDataRow('SOUTH JAKARTA', 'REC.NO.'),
              _buildDataRow('Passport NUMBER', passport_number),
              Divider(),
              _buildDataRow('Issued Date', issuedDate),
              Divider(),
              _buildDataRow('Expire Date', expireDate),
              Divider(),
              // _buildDataRow('BRI', 'B2B3619'),
              // Divider(),

              // Barcode Section
              Image.asset(
                'assets/images/barcode.jpg',
                width: double.infinity,
                height: 90,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
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
}
