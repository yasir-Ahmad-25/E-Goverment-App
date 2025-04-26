import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.10/egov_back/login'),
        body: {'email': _email.text, 'password': _password.text},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        // // Save session data
        // await prefs.setInt('user_id', data['citizen']['citizen_id']);
        // await prefs.setString('email', data['citizen']['email']);

            // Get citizen data (single object)
            final citizen = data['citizen'];
            final citizenId = citizen['citizen_id'];

            // Save to SharedPreferences
            await prefs.setInt('user_id', citizenId is String 
                ? int.parse(citizenId) 
                : citizenId
            );
            await prefs.setString('email', citizen['email']);
            
        if (mounted) {
          Navigator.pushReplacementNamed(context, 'home_screen');
        }
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
