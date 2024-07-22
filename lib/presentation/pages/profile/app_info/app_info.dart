import 'package:flutter/material.dart';
import '../../../../core/utils/constants/constants.dart';
import '../profile_page.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: const Text('App Info'),
          foregroundColor: lightColor,
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ),
        body: const SingleChildScrollView(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(22.0),
              child: Text(
                '''MyExpense is a mobile application designed to help users track and manage their personal expenses efficiently. The app provides features to:

  * Add new expenses
  * View a list of all expenses
  * Edit existing expenses
  * Delete unwanted expenses

Additionally, MyExpense allows you to categorize your expenses for better analysis. You can also view summarized reports of your spending on a weekly or monthly basis. To ensure you don't miss recording any expenses, MyExpense can send you reminder notifications.

Download MyExpense today and take control of your personal finances !!''',
                style: textSize
              ),
            ),
          ),
        ),
      ),
    );
  }
}
