import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_expense_tracker/data/datasources/expense_data_source.dart';
import 'package:personal_expense_tracker/data/models/expense_model.dart';

class MockBox extends Mock implements Box<ExpenseModel> {}

void main() {
  late ExpenseLocalDataSourceImpl dataSource;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    dataSource = ExpenseLocalDataSourceImpl(mockBox);
  });

  test('ExpenseLocalDataSourceImpl initialized', () {
    expect(dataSource, isNotNull);
  });
}
