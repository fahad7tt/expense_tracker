import 'package:flutter/material.dart';

class ExpenseSummaryPage extends StatelessWidget {
  const ExpenseSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Summary')),
      body: const Center(
        child: Text('Summary Page Content Here'),
      ),
    );
  }
}