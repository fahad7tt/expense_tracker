import 'dart:async';
import 'package:flutter/material.dart';

import '../expense_list/expense_list_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ExpenseListPage(),
          ),
        );
      },
    );

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/app_logo.jpeg',
          fit: BoxFit.fill,
          width: 800,
          height: 800,
          ),
      ),
    );
  }
}