import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather03/HomePage/HomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const appName = "Just Weather!";

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(appName: appName)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          appName,
          style: TextStyle(fontSize: 50, fontFamily: 'Pacifico'),
        ),
      ),
    );
  }
}
