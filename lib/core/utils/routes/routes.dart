import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/presentation/pages/expense_list/expense_list_page.dart';
import 'package:personal_expense_tracker/presentation/pages/profile/app_info/app_info.dart';
import 'package:personal_expense_tracker/presentation/pages/profile/privacy_policy/privacy_policy.dart';
import 'package:personal_expense_tracker/presentation/pages/profile/terms_and_conditions/terms_and_conditions.dart';
import 'package:personal_expense_tracker/presentation/pages/expense_summary/expense_summary_pages.dart';
import 'package:personal_expense_tracker/presentation/pages/profile/profile_page.dart';

Map<String, WidgetBuilder> get appRoutes {
  return {
    '/': (context) => ExpenseListPage(),
    '/home': (context) => ExpenseListPage(),
    '/summary': (context) => const ExpenseSummaryPage(),
    '/profile': (context) => const ProfilePage(),
    '/appInfo': (context) => const AppInfo(),
    '/termsAndConditions': (context) => const TermsAndConditions(),
    '/privacyPolicy': (context) => const PrivacyPolicy(),
  };
}

Route<dynamic>? generateRoute(RouteSettings settings) {
  final routes = appRoutes;
  final builder = routes[settings.name];

  if (builder == null) return null;

  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
