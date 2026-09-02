import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/presentation/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_summary_provider.dart';

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
        leading: Icon(leadingIcon, color: Theme.of(context).iconTheme.color),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        trailing: Icon(trailingIcon, color: Theme.of(context).iconTheme.color),
        onTap: onTap,
      ),
    );
  }

  void _showBankInfoDialog(BuildContext context) {
    final provider = Provider.of<ExpenseSummaryProvider>(
      context,
      listen: false,
    );
    final controller = TextEditingController(
      text: provider.initialBankBalance > 0
          ? provider.initialBankBalance.toStringAsFixed(2)
          : '',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.account_balance, color: Colors.blue),
              SizedBox(width: 8),
              Text('Bank Account & Balance'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bank Account Linking',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Live automatic bank linking requires financial aggregator services (e.g. Plaid / Open Banking APIs) and a secure server. In this local app, you can manually set your Total Bank Balance below to keep your Net Balance calculated automatically.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Divider(height: 24),
                const Text(
                  'Initial / Total Bank Balance',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Enter Total Bank Balance',
                    prefixIcon: Icon(Icons.account_balance_wallet),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final val = double.tryParse(controller.text.trim());
                if (val != null && val >= 0) {
                  provider.setInitialBankBalance(val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bank balance updated successfully!'),
                    ),
                  );
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save Balance'),
            ),
          ],
        );
      },
    );
  }
}
