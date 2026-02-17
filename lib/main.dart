import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/app.dart';
import 'core/utils/initialize_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  runApp(const MyApp()); 
}