import 'package:e_govermenet/components/Forms/national_id_card_form.dart';
import 'package:e_govermenet/screens/home_screen.dart';
import 'package:e_govermenet/screens/login_screen.dart';
import 'package:e_govermenet/screens/service_detailed_page.dart';
import 'package:e_govermenet/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final citizenId = prefs.getInt('user_id');
    return citizenId != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // darkTheme: ThemeData.dark(),
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          return snapshot.data == true ? HomeScreen() : LoginScreen();
        },
      ),
      routes: {
        'sign_up': (context) => SignUpScreen(),
        'home_screen': (context) => HomeScreen(),
        'Login': (context) => LoginScreen(),
        // Forms
        'national_id_card_form': (context) => NationalIdCardForm(),
      },
    );
  }
}
