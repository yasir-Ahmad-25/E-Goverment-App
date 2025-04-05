import 'package:e_govermenet/screens/home_screen.dart';
import 'package:e_govermenet/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpScreen(),
      routes: {
        'sign_up': (context) => SignUpScreen(),
        'home_screen': (context) => HomeScreen(),
      },
    );
  }
}
