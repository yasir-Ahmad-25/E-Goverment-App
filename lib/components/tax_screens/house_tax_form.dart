import 'package:flutter/material.dart';

class HouseTaxForm extends StatefulWidget {
  const HouseTaxForm({super.key});

  @override
  _HouseTaxFormState createState() => _HouseTaxFormState();
}

class _HouseTaxFormState extends State<HouseTaxForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController houseNumberController = TextEditingController();
  String? selectedHouseType;
  double taxAmount = 0.0;

  final Map<String, double> taxRates = {
    "Apartment": 200.0,
    "Villa": 500.0,
    "Townhouse": 350.0,
    "Cottage": 150.0,
  };

  void _updateTaxAmount(String? type) {
    setState(() {
      selectedHouseType = type;
      taxAmount = taxRates[type] ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("House Tax Form")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: houseNumberController,
                decoration: InputDecoration(labelText: "House Number"),
                validator:
                    (value) =>
                        value!.isEmpty ? "Please enter house number" : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "House Type"),
                value: selectedHouseType,
                items:
                    taxRates.keys.map((String type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                onChanged: _updateTaxAmount,
                validator:
                    (value) =>
                        value == null ? "Please select a house type" : null,
              ),
              SizedBox(height: 20),
              Text(
                "Tax Amount: \$${taxAmount.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Submit"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save to backend or show confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("House Tax Submitted")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    
    );
  }
}
