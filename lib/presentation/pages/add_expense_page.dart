import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/expense.dart';
import '../providers/expense_provider.dart';
import 'expense_list_page.dart';

// ignore: must_be_immutable
class AddExpensePage extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final amount = double.parse(amountController.text);
                final description = descriptionController.text;

                final expense = Expense(
                  id: DateTime.now().millisecondsSinceEpoch,
                  amount: amount,
                  date: selectedDate,
                  description: description,
                );

                await Provider.of<ExpenseProvider>(context, listen: false)
                    .addNewExpense(expense);

                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ExpenseListPage(),
                      ),
                    );
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Make corners sharp
                  ),
                ),
                child: Text(
                  'Save Expense',
                  style: TextStyle(color: Colors.grey[800]),
                ),
            ),
          ],
        ),
      ),
    );
  }
}