import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future<void> _logout(BuildContext context) async {
  //   try {
  //     if(mounted){

  //       // Clear local storage
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.clear();

  //       // Call backend logout (optional)
  //       await http.post(Uri.parse('https://your-backend.com/auth/logout'));

  //       if (mounted){
  //           // Navigate to login
  //           Navigator.pushReplacementNamed(context, 'Login');
  //       }
  //     }
  //   } catch (e) {
  //     if(mounted){
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Error: ${e.toString()}')),
  //         );
  //     }
  //   }
  // }

  Future<void> _logout() async {
    try {
      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      await http.post(Uri.parse('https://your-backend.com/auth/logout'));

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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
