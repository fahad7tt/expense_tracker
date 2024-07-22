import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/presentation/widgets/bottom_navbar/bottom_navbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildListTile(
            context,
            'App Info',
            Icons.info,
            Icons.arrow_forward_ios,
            onTap: () {
              // Add navigation or action
            },
          ),
          _buildListTile(
            context,
            'Terms and Conditions',
            Icons.description,
            Icons.arrow_forward_ios,
            onTap: () {
              // Add navigation or action
            },
          ),
          _buildListTile(
            context,
            'Privacy Policy',
            Icons.lock,
            Icons.arrow_forward_ios,
            onTap: () {
              // Add navigation or action
            },
          ),
          _buildListTile(
            context,
            'Sign Out',
            Icons.exit_to_app,
            Icons.arrow_forward_ios,
            onTap: () {
              // Add sign out logic
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    IconData leadingIcon,
    IconData trailingIcon, {
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(
          leadingIcon,
          color: Theme.of(context).iconTheme.color,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: Icon(
          trailingIcon,
          color: Theme.of(context).iconTheme.color,
        ),
        onTap: onTap,
      ),
    );
  }
}
