import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () =>
        Navigator.of(context).pushReplacementNamed('/home')
    );

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/app_logo.jpeg',
          fit: BoxFit.fill,
          height: 800,          
          ),
      ),
    );
  }
}