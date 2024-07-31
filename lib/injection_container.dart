import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/datasources/expense_data_source.dart';
import 'data/models/expense_model.dart';
import 'data/repositories/expense_repository_impl.dart';
import 'domain/repositories/expense_repository.dart';
import 'domain/usecases/add_expense.dart';
import 'domain/usecases/fetch_summary_by_type.dart';
import 'domain/usecases/get_all_expenses.dart';
import 'domain/usecases/update_expense.dart';
import 'domain/usecases/delete_expense.dart';
import 'presentation/providers/expense_provider.dart';
import 'presentation/providers/expense_summary_provider.dart';
import 'presentation/providers/navigation_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Hive box for expenses
  final expenseBox = await Hive.openBox<ExpenseModel>('expenses');
  sl.registerLazySingleton<Box<ExpenseModel>>(() => expenseBox);

  // Hive box for custom types
  final typesBox = await Hive.openBox<String>('custom_types');
  sl.registerLazySingleton<Box<String>>(() => typesBox);

  // Data sources
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => AddExpense(sl()));
  sl.registerLazySingleton(() => GetAllExpenses(sl()));
  sl.registerLazySingleton(() => UpdateExpense(sl()));
  sl.registerLazySingleton(() => DeleteExpense(sl()));
  sl.registerLazySingleton(() => FetchExpenseSummaryByType(sl()));

  // Providers
  sl.registerFactory(
    () => ExpenseProvider(
      addExpense: sl(),
      getAllExpenses: sl(),
      updateExpense: sl(),
      deleteExpense: sl(),
    ),
  );
  sl.registerFactory(
    () => ExpenseSummaryProvider(
      fetchSummary: sl(),
    ),
  );
  sl.registerFactory(
    () => NavigationProvider(),
  );
}