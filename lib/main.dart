import 'package:e_govermenet/components/Forms/birth_certificate_form.dart';
import 'package:e_govermenet/components/Forms/business_certificate_form.dart';
import 'package:e_govermenet/components/Forms/driver_license_form.dart';
import 'package:e_govermenet/components/Forms/national_id_card_form.dart';
import 'package:e_govermenet/components/Forms/passport_form.dart';
import 'package:e_govermenet/screens/help_center_screen.dart';
import 'package:e_govermenet/screens/home_screen.dart';
import 'package:e_govermenet/screens/login_screen.dart';
import 'package:e_govermenet/screens/reports_screen.dart';
import 'package:e_govermenet/screens/sign_up_screen.dart';
import 'package:e_govermenet/screens/taxes_screen.dart';
import 'package:e_govermenet/screens/user_profile_screen.dart';
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
      color: Colors.white,
      debugShowCheckedModeBanner: false,
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
        // Registeration and Login
        'sign_up': (context) => SignUpScreen(),
        'Login': (context) => LoginScreen(),

        // App pages
        'home_screen': (context) => HomeScreen(),
        'reports_screen': (context) => ReportsScreen(),
        'taxes': (context) => TaxesScreen(),
        'user_profile': (context) => UserProfileScreen(),
        'help_center': (context) => HelpCenterScreen(),

        // Request Service Forms
        'national_id_card_form': (context) => NationalIdCardForm(),
        'passport_form': (context) => PassportForm(),
        'birth_certificate_form': (context) => BirthCertificateForm(),
        'business_form': (context) => BusinessCertificateForm(),
        'driver_License_form': (context) => DriverLicenseForm(),
      },
    );
  }
}
