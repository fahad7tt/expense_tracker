import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/presentation/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:provider/provider.dart';

import '../../providers/navigation_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<NavigationProvider>(context, listen: false)
                .resetToHome(); 
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text('Profile Page Content'),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
