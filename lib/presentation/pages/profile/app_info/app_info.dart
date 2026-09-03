import 'package:flutter/material.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/theme/system_theme.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Info'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.isDarkMode
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: softBlue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.account_balance_wallet_rounded,
                        color: softBlue, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Expense Tracker',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: context.isDarkMode ? lightColor : deepBlue,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Smart Financial Manager',
                        style: TextStyle(
                          fontSize: 13,
                          color: context.isDarkMode
                              ? lightGrayText
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 32),
              Text(
                'Personal Expense Tracker is a mobile application designed to help users track and manage their personal expenses efficiently.\n\nThe app provides intuitive tools to:\n  • Log new expenses and income\n  • Categorize transactions with rich icons\n  • View 33-33-33 rule budget analytics\n  • Export and filter historical date ranges\n\nTake control of your personal financial health with smart analytics!',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: context.isDarkMode ? lightColor : darkGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
