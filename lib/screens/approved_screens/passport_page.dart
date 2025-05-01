import 'package:flutter/material.dart';

class PassportPage extends StatelessWidget {
  const PassportPage({super.key});

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
                        image: AssetImage('assets/images/person.jpg'),
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
              _buildDataRow('FULL NAME', 'Jaamac Geedi Ali'),
              Divider(),
              _buildDataRow('TYPE', 'Civilian Passport'),
              Divider(),
              // _buildDataRow('IGN', 'NATIONALITY'),
              _buildDataRow('Gender', 'Male'),
              Divider(),
              _buildDataRow('State', 'Banaadir'),
              Divider(),
              _buildDataRow('Birth Date', '29 JAN 2002'),
              Divider(),
              // _buildDataRow('JAKARTA', 'DNT CIP ISSUE'),
              // _buildDataRow('13 FEB 2023', 'DNT CEMPIRO'),
              // _buildDataRow('12 FEB 2023', 'ISSUE GIFICE'),
              // _buildDataRow('SOUTH JAKARTA', 'REC.NO.'),
              _buildDataRow('Passport NUMBER', '1EDK03D093DNC8X'),
              Divider(),
              _buildDataRow('BRI', 'B2B3619'),
              Divider(),

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
