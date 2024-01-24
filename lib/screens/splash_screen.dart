import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate the splash screen
    Timer(
      Duration(seconds: 5),
      () => Navigator.pushReplacementNamed(context, '/HomeScreen'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Center(
        child: Icon(
          Icons.favorite,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }
}
