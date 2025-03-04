import 'dart:async';
import 'package:flutter/material.dart';
import 'Auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "SplashScreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to MainScreen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Image.asset(
        'assets/images/splash screen img.jpg', // Ensure this path is correct
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }
}
