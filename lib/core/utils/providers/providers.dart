import 'package:provider/provider.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_provider.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_summary_provider.dart';
import 'package:personal_expense_tracker/presentation/providers/navigation_provider.dart';
import 'package:personal_expense_tracker/injection_container.dart' as di;

List<ChangeNotifierProvider> get appProviders {
  return [
    ChangeNotifierProvider<ExpenseProvider>(
      create: (_) => di.sl<ExpenseProvider>(),
    ),
    ChangeNotifierProvider<ExpenseSummaryProvider>(
      create: (_) => di.sl<ExpenseSummaryProvider>(),
    ),
    ChangeNotifierProvider<NavigationProvider>(
      create: (_) => di.sl<NavigationProvider>(),
    ),
  ];
}
