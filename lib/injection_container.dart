import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/datasources/expense_data_source.dart';
import 'data/datasources/fixed_item_data_source.dart';
import 'data/models/expense_model.dart';
import 'data/models/fixed_item_model.dart';
import 'data/repositories/expense_repository_impl.dart';
import 'data/repositories/fixed_item_repository_impl.dart';
import 'domain/repositories/expense_repository.dart';
import 'domain/repositories/fixed_item_repository.dart';
import 'domain/usecases/add_expense.dart';
import 'domain/usecases/fetch_summary_by_type.dart';
import 'domain/usecases/get_all_expenses.dart';
import 'domain/usecases/manage_fixed_items.dart';
import 'domain/usecases/update_expense.dart';
import 'domain/usecases/delete_expense.dart';
import 'presentation/providers/expense_provider.dart';
import 'presentation/providers/expense_summary_provider.dart';
import 'presentation/providers/fixed_item_provider.dart';
import 'presentation/providers/navigation_provider.dart';

/// Global Service Locator instance (GetIt)
final sl = GetIt.instance;

/// Initializes all application dependencies (Storage -> DataSources -> Repositories -> UseCases -> Providers).
Future<void> init() async {
  // ==========================================
  // 1. LOCAL STORAGE (Hive Boxes)
  // ==========================================
  final expenseBox = await Hive.openBox<ExpenseModel>('expenses');
  sl.registerLazySingleton<Box<ExpenseModel>>(() => expenseBox);

  final typesBox = await Hive.openBox<String>('custom_types');
  sl.registerLazySingleton<Box<String>>(() => typesBox);

  final fixedItemsBox = await Hive.openBox<FixedItemModel>('fixed_items');
  sl.registerLazySingleton<Box<FixedItemModel>>(() => fixedItemsBox);

  // ==========================================
  // 2. DATA SOURCES (Database Access)
  // ==========================================
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FixedItemLocalDataSource>(
    () => FixedItemLocalDataSourceImpl(sl()),
  );

  // ==========================================
  // 3. REPOSITORIES (Data Abstraction Layer)
  // ==========================================
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<FixedItemRepository>(
    () => FixedItemRepositoryImpl(sl()),
  );

  // ==========================================
  // 4. USE CASES (Business Rules)
  // ==========================================
  sl.registerLazySingleton(() => AddExpense(sl()));
  sl.registerLazySingleton(() => GetAllExpenses(sl()));
  sl.registerLazySingleton(() => UpdateExpense(sl()));
  sl.registerLazySingleton(() => DeleteExpense(sl()));
  sl.registerLazySingleton(() => FetchExpenseSummaryByType(sl()));
  sl.registerLazySingleton(() => GetFixedItems(sl()));
  sl.registerLazySingleton(() => SaveFixedItem(sl()));
  sl.registerLazySingleton(() => DeleteFixedItem(sl()));

  // ==========================================
  // 5. PROVIDERS (State Management for UI)
  // ==========================================
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
    () => FixedItemProvider(
      getFixedItems: sl(),
      saveFixedItem: sl(),
      deleteFixedItem: sl(),
    ),
  );
  sl.registerFactory(
    () => NavigationProvider(),
  );
}