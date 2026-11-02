import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/expense_summary.dart';
import '../../domain/usecases/fetch_summary_by_type.dart';

class ExpenseSummaryProvider with ChangeNotifier {
  final FetchExpenseSummaryByType fetchSummary;
  List<ExpenseSummary> _summaries = [];
  DateTime? _selectedMonth;
  double _initialBankBalance = 0.0;
  double? _customTargetIncome;

  // Wallet reserve state
  double _walletBalance = 0.0;
  List<Map<String, dynamic>> _walletHistory = [];

  // Category targets state
  Map<String, double> _categoryTargets = {};
  Map<String, bool> _categoryIsFixed = {
    'savings': true,
    'investment': true,
    'living': false,
    'donation': false,
    'personal_dev': false,
  };

  // Category spent overrides (keyed by ${year}_${month}_$categoryKey)
  Map<String, double> _categorySpentOverrides = {};

  // Monthly starting net balances (keyed by ${year}_${month})
  Map<String, double> _monthlyInitialBalances = {};
  Map<String, bool> _monthlyBalanceIsSet = {};
  // Monthly closing net balances carried over from previous months
  Map<String, double> _monthlyClosingBalances = {};

  ExpenseSummaryProvider({required this.fetchSummary}) {
    _loadInitialData();
  }

  List<ExpenseSummary> get summaries => _summaries;
  DateTime? get selectedMonth => _selectedMonth;
  double get initialBankBalance => getInitialBankBalanceForMonth(_selectedMonth);
  double? get customTargetIncome => _customTargetIncome;
  double get walletBalance => _walletBalance;
  List<Map<String, dynamic>> get walletHistory => _walletHistory;
  Map<String, double> get categoryTargets => _categoryTargets;
  Map<String, bool> get categoryIsFixed => _categoryIsFixed;
  Map<String, double> get categorySpentOverrides => _categorySpentOverrides;
  Map<String, double> get monthlyInitialBalances => _monthlyInitialBalances;
  Map<String, bool> get monthlyBalanceIsSet => _monthlyBalanceIsSet;
  Map<String, double> get monthlyClosingBalances => _monthlyClosingBalances;

  String getMonthKey([DateTime? date]) {
    final d = date ?? _selectedMonth ?? DateTime.now();
    return '${d.year}_${d.month}';
  }

  bool isBalanceSetForMonth([DateTime? month]) {
    final key = getMonthKey(month);
    return _monthlyBalanceIsSet[key] ?? false;
  }

  /// Returns the starting balance for the given month.
  /// If the month was explicitly set/edited by the user, returns that custom balance.
  /// Otherwise, rolls over the ending net balance from the previous month.
  double getInitialBankBalanceForMonth([DateTime? month]) {
    final target = month ?? _selectedMonth ?? DateTime.now();
    final key = getMonthKey(target);

    // 1. If this month has an explicitly set balance by the user, return it:
    if (_monthlyBalanceIsSet[key] == true &&
        _monthlyInitialBalances.containsKey(key)) {
      return _monthlyInitialBalances[key]!;
    }

    // 2. Otherwise, inherit the ending net balance of the previous month:
    final prevMonth = DateTime(target.year, target.month - 1, 1);
    final prevKey = getMonthKey(prevMonth);
    if (_monthlyClosingBalances.containsKey(prevKey)) {
      return _monthlyClosingBalances[prevKey]!;
    }

    // 3. Fallback to any saved initial balance for this month or previous month
    if (_monthlyInitialBalances.containsKey(key)) {
      return _monthlyInitialBalances[key]!;
    }
    if (_monthlyInitialBalances.containsKey(prevKey)) {
      return _monthlyInitialBalances[prevKey]!;
    }

    return 0.0;
  }

  /// Updates and persists the closing net balance for a month.
  Future<void> updateMonthlyClosingBalance(
    DateTime? month,
    double netBalance,
  ) async {
    final key = getMonthKey(month);
    if (_monthlyClosingBalances[key] == netBalance) return;
    _monthlyClosingBalances[key] = netBalance;
    try {
      final box = await Hive.openBox('settings');
      await box.put('monthly_closing_balances', _monthlyClosingBalances);
    } catch (_) {}
  }

  double? getCategorySpent(String key) {
    final targetMonth = _selectedMonth ?? DateTime.now();
    final monthKey = '${targetMonth.year}_${targetMonth.month}_$key';
    return _categorySpentOverrides[monthKey];
  }

  Future<void> setCategorySpent(String key, double amount) async {
    final targetMonth = _selectedMonth ?? DateTime.now();
    final monthKey = '${targetMonth.year}_${targetMonth.month}_$key';
    _categorySpentOverrides[monthKey] = amount;
    notifyListeners();

    try {
      final box = await Hive.openBox('settings');
      await box.put('category_spent_overrides', _categorySpentOverrides);
    } catch (_) {}
  }

  Future<void> loadCategorySpentOverrides() async {
    try {
      final box = await Hive.openBox('settings');
      final raw = box.get('category_spent_overrides');
      if (raw is Map) {
        _categorySpentOverrides = raw.map(
          (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
        );
        notifyListeners();
      }
    } catch (_) {}
  }

  bool isCategoryFixed(String key) =>
      _categoryIsFixed[key] ?? (key == 'savings' || key == 'investment');

  Future<void> _loadInitialData() async {
    await loadBankBalance();
    await loadTargetIncome();
    await loadWalletData();
    await loadCategoryTargets();
    await loadCategorySpentOverrides();
    await refreshCurrentMonth();
  }

  Future<void> refreshCurrentMonth() async {
    final targetMonth = _selectedMonth ?? DateTime.now();

    // Ensure previous month's closing net balance is ready for rollover
    await _ensurePreviousMonthBalance(targetMonth);

    final startDate = DateTime(targetMonth.year, targetMonth.month, 1);
    final endDate =
        DateTime(targetMonth.year, targetMonth.month + 1, 0, 23, 59, 59, 999);
    await loadSummaries(startDate, endDate);
  }

  Future<void> _ensurePreviousMonthBalance(DateTime targetMonth) async {
    final key = getMonthKey(targetMonth);
    if (_monthlyBalanceIsSet[key] == true) return;

    final prevMonth = DateTime(targetMonth.year, targetMonth.month - 1, 1);
    final prevKey = getMonthKey(prevMonth);
    if (_monthlyClosingBalances.containsKey(prevKey)) return;

    final prevStart = DateTime(prevMonth.year, prevMonth.month, 1);
    final prevEnd =
        DateTime(prevMonth.year, prevMonth.month + 1, 0, 23, 59, 59, 999);
    try {
      final prevSummaries = await fetchSummary.execute(prevStart, prevEnd);
      double profits = 0;
      double expenses = 0;
      for (final s in prevSummaries) {
        if (s.isProfit) {
          profits += s.totalAmount;
        } else {
          expenses += s.totalAmount;
        }
      }
      final prevInitial = _monthlyInitialBalances[prevKey] ?? 0.0;
      final prevNet = prevInitial + profits - expenses;
      _monthlyClosingBalances[prevKey] = prevNet;
      final box = await Hive.openBox('settings');
      await box.put('monthly_closing_balances', _monthlyClosingBalances);
    } catch (_) {}
  }

  Future<void> loadTargetIncome() async {
    try {
      final box = await Hive.openBox('settings');
      final val = box.get('custom_target_income');
      if (val is int) {
        _customTargetIncome = val.toDouble();
      } else if (val is double) {
        _customTargetIncome = val;
      }
      notifyListeners();
    } catch (e) {
      // Handle exception silently
    }
  }

  Future<void> setCustomTargetIncome(double target) async {
    _customTargetIncome = target;
    notifyListeners();
    try {
      final box = await Hive.openBox('settings');
      await box.put('custom_target_income', target);
    } catch (e) {
      // Handle exception silently
    }
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

      final rawBalances = box.get('monthly_initial_balances');
      if (rawBalances is Map) {
        _monthlyInitialBalances = rawBalances.map(
          (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
        );
      }

      final rawIsSet = box.get('monthly_balance_is_set');
      if (rawIsSet is Map) {
        _monthlyBalanceIsSet = rawIsSet.map(
          (k, v) => MapEntry(k.toString(), v == true),
        );
      }

      final rawClosing = box.get('monthly_closing_balances');
      if (rawClosing is Map) {
        _monthlyClosingBalances = rawClosing.map(
          (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
        );
      }

      // If legacy _initialBankBalance exists and no monthly balances exist, migrate to current month
      final currentMonthKey = getMonthKey(_selectedMonth ?? DateTime.now());
      if (_monthlyInitialBalances.isEmpty && _initialBankBalance > 0) {
        _monthlyInitialBalances[currentMonthKey] = _initialBankBalance;
        _monthlyBalanceIsSet[currentMonthKey] = true;
      }

      notifyListeners();
    } catch (e) {
      // Handle exception silently
    }
  }

  /// Sets or edits the net balance for the month directly.
  /// The net balance carries over into future months, and can be edited anytime.
  Future<void> setNetBalanceForMonth(
    double targetNetBalance, {
    DateTime? month,
    required double totalProfits,
    required double totalExpenses,
  }) async {
    final key = getMonthKey(month);
    final startingBal = targetNetBalance - totalProfits + totalExpenses;
    _monthlyInitialBalances[key] = startingBal;
    _monthlyBalanceIsSet[key] = true;
    _monthlyClosingBalances[key] = targetNetBalance;
    _initialBankBalance = startingBal;
    notifyListeners();

    try {
      final box = await Hive.openBox('settings');
      await box.put('monthly_initial_balances', _monthlyInitialBalances);
      await box.put('monthly_balance_is_set', _monthlyBalanceIsSet);
      await box.put('monthly_closing_balances', _monthlyClosingBalances);
      await box.put('initial_bank_balance', _initialBankBalance);
    } catch (_) {}
  }

  /// Sets the starting net balance for the month.
  Future<void> setInitialBankBalanceForMonth(
    double balance, {
    DateTime? month,
  }) async {
    final key = getMonthKey(month);
    _monthlyInitialBalances[key] = balance;
    _monthlyBalanceIsSet[key] = true;
    _initialBankBalance = balance;
    notifyListeners();

    try {
      final box = await Hive.openBox('settings');
      await box.put('monthly_initial_balances', _monthlyInitialBalances);
      await box.put('monthly_balance_is_set', _monthlyBalanceIsSet);
      await box.put('initial_bank_balance', _initialBankBalance);
    } catch (_) {}
  }

  Future<void> setInitialBankBalance(double balance) async {
    await setInitialBankBalanceForMonth(balance, month: _selectedMonth);
  }

  // ==========================================
  // WALLET RESERVE (END-OF-MONTH SURPLUS)
  // ==========================================

  Future<void> loadWalletData() async {
    try {
      final box = await Hive.openBox('settings');
      final val = box.get('wallet_balance', defaultValue: 0.0);
      if (val is num) {
        _walletBalance = val.toDouble();
      }
      final hist = box.get('wallet_history');
      if (hist is List) {
        _walletHistory = hist
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      notifyListeners();
    } catch (_) {}
  }

  /// Saves money from the monthly net balance into the Wallet Reserve vault.
  Future<bool> depositToWallet(double amount, {String? note}) async {
    if (amount <= 0) return false;
    _walletBalance += amount;

    final key = getMonthKey(_selectedMonth);
    final currentMonthBal = getInitialBankBalanceForMonth(_selectedMonth);
    final updatedBal = (currentMonthBal - amount).clamp(0.0, double.infinity);
    _monthlyInitialBalances[key] = updatedBal;
    _initialBankBalance = updatedBal;

    _walletHistory.insert(0, {
      'date': DateTime.now().toIso8601String(),
      'type': 'deposit',
      'amount': amount,
      'note': note ?? 'Deposit to wallet reserve',
    });

    notifyListeners();

    try {
      final box = await Hive.openBox('settings');
      await box.put('wallet_balance', _walletBalance);
      await box.put('monthly_initial_balances', _monthlyInitialBalances);
      await box.put('initial_bank_balance', _initialBankBalance);
      await box.put('wallet_history', _walletHistory);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Withdraws saved money from the Wallet Reserve vault into the monthly net balance.
  Future<bool> withdrawFromWallet(double amount, {String? note}) async {
    if (amount <= 0 || amount > _walletBalance) return false;
    _walletBalance -= amount;

    final key = getMonthKey(_selectedMonth);
    final currentMonthBal = getInitialBankBalanceForMonth(_selectedMonth);
    final updatedBal = currentMonthBal + amount;
    _monthlyInitialBalances[key] = updatedBal;
    _initialBankBalance = updatedBal;

    _walletHistory.insert(0, {
      'date': DateTime.now().toIso8601String(),
      'type': 'withdraw',
      'amount': amount,
      'note': note ?? 'Withdraw from wallet reserve',
    });

    notifyListeners();

    try {
      final box = await Hive.openBox('settings');
      await box.put('wallet_balance', _walletBalance);
      await box.put('monthly_initial_balances', _monthlyInitialBalances);
      await box.put('initial_bank_balance', _initialBankBalance);
      await box.put('wallet_history', _walletHistory);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ==========================================
  // FLEXIBLE CATEGORY TARGETS & ALLOCATION
  // ==========================================

  Future<void> loadCategoryTargets() async {
    try {
      final box = await Hive.openBox('settings');
      final rawTargets = box.get('category_targets');
      if (rawTargets is Map) {
        _categoryTargets = rawTargets.map(
          (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
        );
      }
      final rawFixed = box.get('category_is_fixed');
      if (rawFixed is Map) {
        _categoryIsFixed = rawFixed.map(
          (k, v) => MapEntry(k.toString(), v as bool),
        );
      }
      notifyListeners();
    } catch (_) {}
  }

  /// Calculates effective category targets based on [baseIncome].
  ///
  /// Categories marked [isFixed] keep their fixed budget amount.
  /// Remaining income is distributed across dynamic categories.
  Map<String, double> getEffectiveTargets(double baseIncome) {
    const defaultRatios = {
      'living': 8.0 / 24.0,
      'investment': 5.0 / 24.0,
      'savings': 5.0 / 24.0,
      'donation': 3.0 / 24.0,
      'personal_dev': 3.0 / 24.0,
    };

    final Map<String, double> result = {};

    // 1. Calculate fixed categories
    double totalFixed = 0.0;
    for (final key in defaultRatios.keys) {
      final bool isFixed = isCategoryFixed(key);
      if (isFixed) {
        final double fixedAmount = _categoryTargets[key] ??
            (baseIncome * defaultRatios[key]!);
        result[key] = fixedAmount;
        totalFixed += fixedAmount;
      }
    }

    // 2. Distribute remaining income among dynamic categories
    final double remainingIncome =
        (baseIncome - totalFixed).clamp(0.0, double.infinity);
    double dynamicWeightsSum = 0.0;
    for (final key in defaultRatios.keys) {
      if (!isCategoryFixed(key)) {
        dynamicWeightsSum += defaultRatios[key]!;
      }
    }

    for (final key in defaultRatios.keys) {
      if (!isCategoryFixed(key)) {
        if (_categoryTargets.containsKey(key) &&
            _categoryTargets[key]! > 0 &&
            dynamicWeightsSum == 0) {
          result[key] = _categoryTargets[key]!;
        } else if (dynamicWeightsSum > 0) {
          final double ratio = defaultRatios[key]! / dynamicWeightsSum;
          result[key] = remainingIncome * ratio;
        } else {
          result[key] = remainingIncome / 3;
        }
      }
    }

    return result;
  }

  /// Manually sets a category's target and optional fixed status.
  Future<void> setCategoryTarget(
    String key,
    double amount, {
    bool? isFixed,
  }) async {
    _categoryTargets[key] = amount;
    if (isFixed != null) {
      _categoryIsFixed[key] = isFixed;
    }
    notifyListeners();

    try {
      final box = await Hive.openBox('settings');
      await box.put('category_targets', _categoryTargets);
      await box.put('category_is_fixed', _categoryIsFixed);
    } catch (_) {}
  }

  /// Toggles whether a category has a fixed target amount.
  Future<void> toggleCategoryFixedMode(
    String key, {
    double? currentTarget,
  }) async {
    final bool currentMode = isCategoryFixed(key);
    _categoryIsFixed[key] = !currentMode;
    if (!currentMode && currentTarget != null) {
      _categoryTargets[key] = currentTarget;
    }
    notifyListeners();

    try {
      final box = await Hive.openBox('settings');
      await box.put('category_is_fixed', _categoryIsFixed);
      if (currentTarget != null) {
        await box.put('category_targets', _categoryTargets);
      }
    } catch (_) {}
  }

  /// Calibrates targets to match a new baseline income (e.g. current profit or custom income),
  /// preserving fixed amounts for locked categories while scaling dynamic categories.
  Future<void> calibrateTargetsToIncome(double newIncome) async {
    _customTargetIncome = newIncome;
    final updatedTargets = getEffectiveTargets(newIncome);
    _categoryTargets.addAll(updatedTargets);
    notifyListeners();

    try {
      final box = await Hive.openBox('settings');
      await box.put('custom_target_income', newIncome);
      await box.put('category_targets', _categoryTargets);
    } catch (_) {}
  }

  void setSelectedMonth(DateTime month) {
    _selectedMonth = month;
    notifyListeners();
  }

  Future<void> loadSummaries(DateTime startDate, DateTime endDate) async {
    try {
      _summaries = await fetchSummary.execute(startDate, endDate);
    } catch (e) {
      // ignore: avoid_print
      print('Error loading summaries: $e');
    }
    notifyListeners();
  }
}

