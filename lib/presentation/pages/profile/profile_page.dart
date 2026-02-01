import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/presentation/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

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
            onTap: () => Navigator.pushNamed(context, '/appInfo'),
          ),
          _buildListTile(
            context,
            'Terms & Conditions',
            Icons.description,
            Icons.arrow_forward_ios,
            onTap: () => Navigator.pushNamed(context, '/termsAndConditions'),
          ),
          _buildListTile(
            context,
            'Privacy Policy',
            Icons.lock,
            Icons.arrow_forward_ios,
            onTap: () => Navigator.pushNamed(context, '/privacyPolicy'),
          ),
          const SizedBox(height: 22),
          Center(
            child: Text(
              'Version $_version',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
            ),
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
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      elevation: 3,
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
