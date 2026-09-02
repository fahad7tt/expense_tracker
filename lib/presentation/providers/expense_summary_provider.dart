import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/expense_summary.dart';
import '../../domain/usecases/fetch_summary_by_type.dart';

class ExpenseSummaryProvider with ChangeNotifier {
  final FetchExpenseSummaryByType fetchSummary;
  List<ExpenseSummary> _summaries = [];
  DateTime? _selectedMonth;
  double _initialBankBalance = 0.0;

  ExpenseSummaryProvider({required this.fetchSummary}) {
    _loadInitialData();
  }

  List<ExpenseSummary> get summaries => _summaries;
  DateTime? get selectedMonth => _selectedMonth;
  double get initialBankBalance => _initialBankBalance;

  Future<void> _loadInitialData() async {
    await loadBankBalance();
    final now = DateTime.now();
    await loadSummaries(DateTime(now.year, now.month, 1),
        DateTime(now.year, now.month + 1, 0));
  }

  Future<void> loadBankBalance() async {
    try {
      final box = await Hive.openBox('settings');
      final val = box.get('initial_bank_balance', defaultValue: 0.0);
      if (val is int) {
        _initialBankBalance = val.toDouble();
      } else if (val is double) {
        _initialBankBalance = val;
      } else {
        _initialBankBalance = 0.0;
      }
      notifyListeners();
    } catch (e) {
      // Handle exception silently
    }
  }

  Future<void> setInitialBankBalance(double balance) async {
    _initialBankBalance = balance;
    notifyListeners();
    try {
      final box = await Hive.openBox('settings');
      await box.put('initial_bank_balance', balance);
    } catch (e) {
      // Handle exception silently
    }
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
      // ignore: avoid_print
      print('Error loading summaries: $e');
    }
    notifyListeners();
  }
}

