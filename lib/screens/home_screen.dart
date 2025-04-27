import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _fullName;
  String? _gender;
  String? _userStatus;
  bool _isActive = false;
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
            _gender = data['data']['gender'];
            _userStatus = data['data']['status'];
            if (_userStatus == 'Active') {
              _isActive = true;
            }

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome , $_fullName 🔥", style: TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Bootstrap.person_circle),
            onPressed: () {
              if (kDebugMode) {
                print("Profile Icon Has Been Clicked");
              }
            },
          ),
        ],
      ),
      body:
          _isActive
              ? Center(child: Text("Welcome Home Citizen 🔥"))
              : PendingUser(gender: _gender.toString(), function: _logout),
    );
  }
}

class PendingUser extends StatelessWidget {
  final String gender;
  final VoidCallback function;
  const PendingUser({super.key, required this.gender, required this.function});

  @override
  Widget build(BuildContext context) {
    return Center(
      /** Card Widget **/
      child: Card(
        elevation: 25,
        shadowColor: Colors.black,
        color: Colors.white,
        child: SizedBox(
          width: 300,
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 70,
                  child: const CircleAvatar(
                    backgroundImage: NetworkImage(
                      // "https://media.geeksforgeeks.org/wp-content/uploads/20210101144014/gfglogo.png",
                      "https://www.ecss-online.com/2013/wp-content/uploads/2022/12/somalia.jpg",
                    ), //NetworkImage
                    radius: 100,
                  ), //CircleAvatar
                ), //CircleAvatar
                const SizedBox(height: 10), //SizedBox
                Text(
                  'Salaan ${(gender == 'Male') ? 'Mudane' : 'Marwo'}',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w500,
                  ), //Textstyle
                ), //Text
                const SizedBox(height: 10), //SizedBox
                const Text(
                  'Account Sida ugu dhaqsiyaha badan ayaa la xaqiijin doona ? Waaku Mahadsantahay Waqtigaaga.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ), //Textstyle
                ), //Text
                const SizedBox(height: 15), //SizedBox
                Center(
                  child: ElevatedButton(
                    onPressed: function,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.redAccent,
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Prevents stretching
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Bootstrap.box_arrow_left, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Logout', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ), //Column
          ), //Padding
        ), //SizedBox
      ), //Card
    ); //Center
  }
}
