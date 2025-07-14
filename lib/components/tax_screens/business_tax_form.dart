import 'package:flutter/material.dart';

class BusinessTaxForm extends StatefulWidget {
  const BusinessTaxForm({super.key});

  @override
  _BusinessTaxFormState createState() => _BusinessTaxFormState();
}

class _BusinessTaxFormState extends State<BusinessTaxForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController businessNameController = TextEditingController();
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController annualIncomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: businessNameController,
              decoration: InputDecoration(labelText: "Business Name"),
              validator:
                  (value) =>
                      value!.isEmpty ? "Please enter business name" : null,
            ),
            TextFormField(
              controller: licenseNumberController,
              decoration: InputDecoration(labelText: "License Number"),
              validator:
                  (value) =>
                      value!.isEmpty ? "Please enter license number" : null,
            ),
            TextFormField(
              controller: annualIncomeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Annual Income (\$)"),
              validator:
                  (value) => value!.isEmpty ? "Please enter income" : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Submit"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Save to backend or show confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Business Tax Submitted")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  
  }
}
