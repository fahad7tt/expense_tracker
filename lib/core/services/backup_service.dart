import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_expense_tracker/data/models/expense_model.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_provider.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_summary_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  static Future<bool> exportBackup(BuildContext context) async {
    try {
      final expenseBox = await Hive.openBox<ExpenseModel>('expenses');
      final settingsBox = await Hive.openBox('settings');

      final double initialBankBalance =
          settingsBox.get('initial_bank_balance', defaultValue: 0.0) is num
              ? (settingsBox.get('initial_bank_balance') as num).toDouble()
              : 0.0;

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

      final Map<String, dynamic> backupData = {
        'app': 'personal_expense_tracker',
        'version': '1.0',
        'exported_at': DateTime.now().toIso8601String(),
        'initial_bank_balance': initialBankBalance,
        'expenses': expenseJsonList,
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

      if (!decodedData.containsKey('expenses')) {
        throw const FormatException('Invalid backup file format');
      }

      final expenseBox = await Hive.openBox<ExpenseModel>('expenses');
      final settingsBox = await Hive.openBox('settings');

      await expenseBox.clear();

      final List<dynamic> jsonExpenses =
          decodedData['expenses'] as List<dynamic>;
      for (final item in jsonExpenses) {
        final Map<String, dynamic> expMap = item as Map<String, dynamic>;
        final ExpenseModel model = ExpenseModel(
          id: expMap['id'] as int,
          amount: (expMap['amount'] as num).toDouble(),
          date: DateTime.parse(expMap['date'] as String),
          description: expMap['description'] as String,
          type: expMap['type'] as String?,
          currency: expMap['currency'] as String?,
          isProfit: expMap['isProfit'] as bool? ?? false,
        );
        await expenseBox.put(model.id, model);
      }

      if (decodedData.containsKey('initial_bank_balance')) {
        final double balance =
            (decodedData['initial_bank_balance'] as num).toDouble();
        await settingsBox.put('initial_bank_balance', balance);
      }

      // Reload providers
      if (context.mounted) {
        final expenseProvider =
            Provider.of<ExpenseProvider>(context, listen: false);
        final summaryProvider =
            Provider.of<ExpenseSummaryProvider>(context, listen: false);

        await expenseProvider.fetchAllExpenses();
        await summaryProvider.loadBankBalance();
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
