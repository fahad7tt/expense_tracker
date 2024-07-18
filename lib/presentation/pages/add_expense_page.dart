import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/expense.dart';
import '../providers/expense_provider.dart';
import 'expense_list_page.dart';

class AddExpensePage extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy'); // Date format

  AddExpensePage({Key? key}) : super(key: key);

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter description';
    } else if (value.length < 20) {
      return 'Description must be at least 20 characters';
    } else if (value.contains(RegExp(r'[0-9]'))) {
      return 'Description must not contain numbers';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 22.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: InputBorder.none,
                ),
                validator: validateDescription,
                maxLines: 3
              ),
            ),
            const SizedBox(height: 22.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ValueListenableBuilder<DateTime>(
                valueListenable: selectedDate,
                builder: (context, date, child) {
                  return ListTile(
                    title: Text(
                      dateFormat.format(date),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != date) {
                        selectedDate.value = picked;
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 28.0),
            ElevatedButton(
              onPressed: () async {
                if (Form.of(context).validate()) {
                  final amount = double.parse(amountController.text);
                  final description = descriptionController.text;

                  final expense = Expense(
                    id: DateTime.now().millisecondsSinceEpoch,
                    amount: amount,
                    date: selectedDate.value,
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
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Sharp corners
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