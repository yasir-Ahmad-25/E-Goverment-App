import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? _fullName;
  bool _isLoading = true;

  // Logout
  Future<void> _logout() async {
    try {
      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      await http.post(Uri.parse('http://192.168.100.10/egov_back/logout'));

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, 'Login');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

   @override
  void initState() {
    super.initState();
    _loadCitizenData();
  }

  Future<void> _loadCitizenData() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final citizenId = prefs.getInt('user_id');

      if (citizenId == null) {
        throw Exception("User ID not found in preferences");
      }

      // Fetch citizen data
      final response = await http.get(
        Uri.parse('http://192.168.100.10/egov_back/citizen/$citizenId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _fullName = data['data']['fullname'];
            _isLoading = false;
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$_fullName"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(),
          ),
        ],
      ),
      body: Center(child: Text("Welcome To Home Citizen 🔥")),
    );
  }
}
