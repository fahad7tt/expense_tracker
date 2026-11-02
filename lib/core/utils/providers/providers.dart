import 'package:provider/provider.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_provider.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_summary_provider.dart';
import 'package:personal_expense_tracker/presentation/providers/fixed_item_provider.dart';
import 'package:personal_expense_tracker/presentation/providers/navigation_provider.dart';
import 'package:personal_expense_tracker/injection_container.dart' as di;

List<ChangeNotifierProvider> get appProviders {
  final expenseProvider = di.sl<ExpenseProvider>();
  final summaryProvider = di.sl<ExpenseSummaryProvider>();

  // Automatically refresh monthly summaries whenever an expense is added, modified, or removed
  expenseProvider.onExpensesChanged = () {
    summaryProvider.refreshCurrentMonth();
  };

  return [
    ChangeNotifierProvider<ExpenseProvider>.value(
      value: expenseProvider,
    ),
    ChangeNotifierProvider<ExpenseSummaryProvider>.value(
      value: summaryProvider,
    ),
    ChangeNotifierProvider<FixedItemProvider>(
      create: (_) => di.sl<FixedItemProvider>(),
    ),
    ChangeNotifierProvider<NavigationProvider>(
      create: (_) => di.sl<NavigationProvider>(),
    ),
  ];
}
