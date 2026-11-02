import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_expense_tracker/core/utils/helpers/monthly_cycle_helper.dart';
import 'package:personal_expense_tracker/data/models/expense_model.dart';
import 'package:personal_expense_tracker/data/models/fixed_item_model.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_provider.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_summary_provider.dart';
import 'package:personal_expense_tracker/presentation/providers/fixed_item_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  static Future<bool> exportBackup(BuildContext context) async {
    try {
      final expenseBox = await Hive.openBox<ExpenseModel>('expenses');
      final settingsBox = await Hive.openBox('settings');
      final fixedItemsBox = await Hive.openBox<FixedItemModel>('fixed_items');

      final dynamic rawBankBalance =
          settingsBox.get('initial_bank_balance', defaultValue: 0.0);
      final double initialBankBalance =
          rawBankBalance is num ? rawBankBalance.toDouble() : 0.0;

      final dynamic rawCycleDay = settingsBox.get(
        MonthlyCycleHelper.cycleStartDayKey,
        defaultValue: MonthlyCycleHelper.defaultCycleStartDay,
      );
      final int monthlyCycleStartDay =
          rawCycleDay is int && rawCycleDay >= 1 && rawCycleDay <= 31
              ? rawCycleDay
              : MonthlyCycleHelper.defaultCycleStartDay;

      final List<Map<String, dynamic>> expenseJsonList =
          expenseBox.values.map((model) {
        return {
          'id': model.id,
          'amount': model.amount,
          'date': model.date.toIso8601String(),
          'description': model.description,
          'type': model.type,
          'currency': model.currency,
          'isProfit': model.isProfit ?? false,
        };
      }).toList();

      final List<Map<String, dynamic>> fixedItemsJsonList =
          fixedItemsBox.values.map((model) {
        return {
          'id': model.id,
          'title': model.title,
          'amount': model.amount,
          'isIncome': model.isIncome,
          'category': model.category,
          'currency': model.currency,
          'isActive': model.isActive ?? true,
        };
      }).toList();

      final dynamic rawTargetIncome = settingsBox.get('custom_target_income');
      final double? customTargetIncome =
          rawTargetIncome is num ? rawTargetIncome.toDouble() : null;

      final dynamic rawWalletBalance =
          settingsBox.get('wallet_balance', defaultValue: 0.0);
      final double walletBalance =
          rawWalletBalance is num ? rawWalletBalance.toDouble() : 0.0;

      final dynamic rawWalletHistory = settingsBox.get('wallet_history');
      final List<Map<String, dynamic>> walletHistory = rawWalletHistory is List
          ? rawWalletHistory
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList()
          : [];

      final dynamic rawCategoryTargets = settingsBox.get('category_targets');
      final Map<String, double> categoryTargets = rawCategoryTargets is Map
          ? rawCategoryTargets.map(
              (k, v) => MapEntry(k.toString(), (v as num).toDouble()))
          : {};

      final dynamic rawCategoryIsFixed = settingsBox.get('category_is_fixed');
      final Map<String, bool> categoryIsFixed = rawCategoryIsFixed is Map
          ? rawCategoryIsFixed.map((k, v) => MapEntry(k.toString(), v as bool))
          : {};

      final Map<String, dynamic> backupData = {
        'app': 'personal_expense_tracker',
        'version': '1.2',
        'exported_at': DateTime.now().toIso8601String(),
        'initial_bank_balance': initialBankBalance,
        'monthly_cycle_start_day': monthlyCycleStartDay,
        'custom_target_income': customTargetIncome,
        'wallet_balance': walletBalance,
        'wallet_history': walletHistory,
        'category_targets': categoryTargets,
        'category_is_fixed': categoryIsFixed,
        'expenses': expenseJsonList,
        'fixed_items': fixedItemsJsonList,
      };

      final String jsonString =
          const JsonEncoder.withIndent('  ').convert(backupData);

      final tempDir = await getTemporaryDirectory();
      final String fileName =
          'expense_tracker_backup_${DateTime.now().millisecondsSinceEpoch}.json';
      final File backupFile = File('${tempDir.path}/$fileName');
      await backupFile.writeAsString(jsonString);

      await Share.shareXFiles(
        [XFile(backupFile.path)],
        subject: 'Expense Tracker Backup',
        text:
            'Backup data file created on ${DateTime.now().toString().split('.')[0]}',
      );

      return true;
    } catch (e) {
      debugPrint('Export Backup Error: $e');
      return false;
    }
  }

  static Future<bool> importBackup(BuildContext context) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result == null || result.files.single.path == null) {
        return false;
      }

      final File pickedFile = File(result.files.single.path!);
      final String jsonContent = await pickedFile.readAsString();
      final Map<String, dynamic> decodedData =
          jsonDecode(jsonContent) as Map<String, dynamic>;

      final dynamic rawExpenses = decodedData['expenses'];
      if (rawExpenses is! List) {
        throw const FormatException('Invalid backup file format');
      }

      final expenseBox = await Hive.openBox<ExpenseModel>('expenses');
      final settingsBox = await Hive.openBox('settings');
      final fixedItemsBox = await Hive.openBox<FixedItemModel>('fixed_items');

      await expenseBox.clear();

      for (final item in rawExpenses) {
        if (item is! Map) continue;
        final expMap = Map<String, dynamic>.from(item);
        final dynamic rawId = expMap['id'];
        final int id = rawId is num
            ? rawId.toInt()
            : (int.tryParse(rawId?.toString() ?? '') ??
                DateTime.now().millisecondsSinceEpoch);
        final dynamic rawAmount = expMap['amount'];
        final double amount = rawAmount is num
            ? rawAmount.toDouble()
            : (double.tryParse(rawAmount?.toString() ?? '') ?? 0.0);
        final dynamic rawDate = expMap['date'];
        final DateTime date = rawDate is String
            ? (DateTime.tryParse(rawDate) ?? DateTime.now())
            : DateTime.now();

        final ExpenseModel model = ExpenseModel(
          id: id,
          amount: amount,
          date: date,
          description: expMap['description']?.toString() ?? '',
          type: expMap['type']?.toString(),
          currency: expMap['currency']?.toString(),
          isProfit: expMap['isProfit'] as bool? ?? false,
        );
        await expenseBox.put(model.id, model);
      }

      if (decodedData.containsKey('fixed_items')) {
        await fixedItemsBox.clear();
        final dynamic rawFixed = decodedData['fixed_items'];
        if (rawFixed is List) {
          for (final item in rawFixed) {
            if (item is! Map) continue;
            final fMap = Map<String, dynamic>.from(item);
            final dynamic rawAmount = fMap['amount'];
            final double amount = rawAmount is num
                ? rawAmount.toDouble()
                : (double.tryParse(rawAmount?.toString() ?? '') ?? 0.0);

            final FixedItemModel model = FixedItemModel(
              id: fMap['id']?.toString() ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              title: fMap['title']?.toString() ?? '',
              amount: amount,
              isIncome: fMap['isIncome'] as bool? ?? false,
              category: fMap['category']?.toString(),
              currency: fMap['currency']?.toString(),
              isActive: fMap['isActive'] as bool? ?? true,
            );
            await fixedItemsBox.put(model.id, model);
          }
        }
      }

      if (decodedData.containsKey('initial_bank_balance')) {
        final dynamic rawBal = decodedData['initial_bank_balance'];
        final double balance = rawBal is num
            ? rawBal.toDouble()
            : (double.tryParse(rawBal?.toString() ?? '') ?? 0.0);
        await settingsBox.put('initial_bank_balance', balance);
      }

      if (decodedData.containsKey('monthly_cycle_start_day')) {
        final dynamic rawCycle = decodedData['monthly_cycle_start_day'];
        final int cycleDay = rawCycle is num
            ? rawCycle.toInt()
            : (int.tryParse(rawCycle?.toString() ?? '') ??
                MonthlyCycleHelper.defaultCycleStartDay);
        await settingsBox.put(MonthlyCycleHelper.cycleStartDayKey, cycleDay);
      }

      if (decodedData.containsKey('custom_target_income')) {
        final dynamic rawTgt = decodedData['custom_target_income'];
        if (rawTgt is num) {
          await settingsBox.put('custom_target_income', rawTgt.toDouble());
        }
      }

      if (decodedData.containsKey('wallet_balance')) {
        final dynamic rawWBal = decodedData['wallet_balance'];
        if (rawWBal is num) {
          await settingsBox.put('wallet_balance', rawWBal.toDouble());
        }
      }

      if (decodedData.containsKey('wallet_history')) {
        final dynamic rawWHist = decodedData['wallet_history'];
        if (rawWHist is List) {
          await settingsBox.put('wallet_history', rawWHist);
        }
      }

      if (decodedData.containsKey('category_targets')) {
        final dynamic rawCTgt = decodedData['category_targets'];
        if (rawCTgt is Map) {
          await settingsBox.put('category_targets', rawCTgt);
        }
      }

      if (decodedData.containsKey('category_is_fixed')) {
        final dynamic rawCFixed = decodedData['category_is_fixed'];
        if (rawCFixed is Map) {
          await settingsBox.put('category_is_fixed', rawCFixed);
        }
      }

      // Reload providers
      if (context.mounted) {
        final expenseProvider =
            Provider.of<ExpenseProvider>(context, listen: false);
        final summaryProvider =
            Provider.of<ExpenseSummaryProvider>(context, listen: false);
        final fixedProvider =
            Provider.of<FixedItemProvider>(context, listen: false);

        await expenseProvider.fetchAllExpenses();
        await summaryProvider.loadBankBalance();
        await summaryProvider.loadTargetIncome();
        await summaryProvider.loadWalletData();
        await summaryProvider.loadCategoryTargets();
        await fixedProvider.loadFixedItems();

        final now = DateTime.now();
        await summaryProvider.loadSummaries(
          DateTime(now.year, now.month, 1),
          DateTime(now.year, now.month + 1, 0),
        );
      }

      return true;
    } catch (e) {
      debugPrint('Import Backup Error: $e');
      return false;
    }
  }
}
