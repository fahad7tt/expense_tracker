import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/domain/entities/expense_summary.dart';
import '../../domain/usecases/fetch_summary_by_type.dart';

class ExpenseSummaryProvider with ChangeNotifier {
  final FetchExpenseSummaryByType fetchSummary;
  List<ExpenseSummary> _summaries = [];
  DateTime? _selectedMonth;

  ExpenseSummaryProvider({required this.fetchSummary});

  List<ExpenseSummary> get summaries => _summaries;
  DateTime? get selectedMonth => _selectedMonth;

  void setSelectedMonth(DateTime month) {
    _selectedMonth = month;
    notifyListeners();
  }

  Future<void> loadSummaries(DateTime startDate, DateTime endDate) async {
    _summaries = await fetchSummary.execute(startDate, endDate);
    notifyListeners();
  }
}
