import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_summary_provider.dart';

class ExpenseSummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Summary'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              final now = DateTime.now();
              final startDate = DateTime(now.year, now.month, 1); // Start of the month
              final endDate = DateTime(now.year, now.month + 1, 0); // End of the month

              Provider.of<ExpenseSummaryProvider>(context, listen: false)
                  .loadSummaries(startDate, endDate);
            },
            child: Text('Load Monthly Summary'),
          ),
          Expanded(
            child: Consumer<ExpenseSummaryProvider>(
              builder: (context, provider, child) {
                final summaries = provider.summaries;
                return ListView.builder(
                  itemCount: summaries.length,
                  itemBuilder: (context, index) {
                    final summary = summaries[index];
                    return ListTile(
                      title: Text(summary.type),
                      subtitle: Text('Total: ₹${summary.totalAmount}'),
                      trailing: Text('Count: ${summary.count}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
