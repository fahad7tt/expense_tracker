import 'package:flutter/material.dart';
import '../../domain/entities/expense_summary.dart';
import '../../domain/usecases/fetch_summary_by_type.dart';

class ExpenseSummaryProvider with ChangeNotifier {
  final FetchExpenseSummaryByType fetchSummary;
  List<ExpenseSummary> _summaries = [];
  DateTime? _selectedMonth;

  ExpenseSummaryProvider({required this.fetchSummary}) {
    // Optionally, you can load summaries when provider is initialized
    _loadInitialSummaries();
  }

  List<ExpenseSummary> get summaries => _summaries;
  DateTime? get selectedMonth => _selectedMonth;

  Future<void> _loadInitialSummaries() async {
    final now = DateTime.now();
    await loadSummaries(DateTime(now.year, now.month, 1),
        DateTime(now.year, now.month + 1, 0));
  }

  void setSelectedMonth(DateTime month) {
    _selectedMonth = month;
    notifyListeners();
  }

  Future<void> loadSummaries(DateTime startDate, DateTime endDate) async {
    try {
      _summaries = await fetchSummary.execute(startDate, endDate);
    } catch (e) {
      // Handle exceptions and possibly notify listeners of an error
      print('Error loading summaries: $e');
    }
    notifyListeners();
  }
}
