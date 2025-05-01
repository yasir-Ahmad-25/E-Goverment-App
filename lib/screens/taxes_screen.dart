import 'dart:convert';

import 'package:e_govermenet/screens/Tax_Payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TaxesScreen extends StatefulWidget {
  const TaxesScreen({super.key});

  @override
  State<TaxesScreen> createState() => _TaxesScreenState();
}

class _TaxesScreenState extends State<TaxesScreen> {
  List<Tax> _taxes = [];

  Future<void> _loadTaxes() async {
    try {
      // Fetch services data
      final response = await http.get(
        Uri.parse('http://192.168.100.10/egov_back/taxes/'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _taxes = List<Tax>.from(
              data['taxes'].map((item) => Tax.fromJson(item)),
            );
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception("Failed To Fetch Taxes: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTaxes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Taxes")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _taxes.length,
              itemBuilder: (context, index) {
                return Taxes(tax: _taxes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Taxes extends StatelessWidget {
  final Tax tax;

  const Taxes({super.key, required this.tax});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(tax);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // optional background color
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12.0), // <-- border radius
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaxPayment(tax: tax)),
              );
            },
            title: Text(tax.categoryName),
            subtitle: Text(tax.description),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
      ),
    );
  }
}

// Model
class Tax {
  final int categoryId;
  final String categoryName;
  final String description;

  Tax({
    required this.categoryId,
    required this.categoryName,
    required this.description,
  });

  factory Tax.fromJson(Map<String, dynamic> json) {
    return Tax(
      categoryId: int.parse(json['category_id']),
      categoryName: json['category_name'],
      description: json['description'],
    );
  }
}
