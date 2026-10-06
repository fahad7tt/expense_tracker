import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:personal_expense_tracker/core/services/backup_service.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:personal_expense_tracker/core/utils/helpers/monthly_cycle_helper.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';
import 'package:personal_expense_tracker/presentation/providers/expense_provider.dart';
import 'package:personal_expense_tracker/presentation/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:provider/provider.dart';

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
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          final cycleDay = expenseProvider.cycleStartDay;
          final cycleLabel = MonthlyCycleHelper.getCycleLabel(cycleDay);

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            children: [
              _buildListTile(
                context,
                'Monthly Expense Cycle',
                Icons.calendar_month_rounded,
                subtitle: 'Current cycle: $cycleLabel (Day $cycleDay)',
                onTap: () => _showMonthlyCycleDialog(context, expenseProvider),
              ),
              const SizedBox(height: 10),
              _buildListTile(
                context,
                'Fixed Expenses & Income',
                Icons.repeat_rounded,
                subtitle: 'Manage recurring monthly income & expenses',
                onTap: () => Navigator.pushNamed(context, '/fixedItems'),
              ),
              const SizedBox(height: 10),
              _buildListTile(
                context,
                'Export Backup Data',
                Icons.cloud_upload_outlined,
                subtitle: 'Save JSON backup to Drive / Files',
                onTap: () async {
                  final success = await BackupService.exportBackup(context);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Backup file created & ready to share!'
                              : 'Export failed or cancelled.',
                        ),
                        backgroundColor: success ? softBlue : Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              _buildListTile(
                context,
                'Restore Backup Data',
                Icons.cloud_download_outlined,
                subtitle: 'Import saved JSON backup file',
                onTap: () async {
                  final success = await BackupService.importBackup(context);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Backup restored successfully!'
                              : 'Restore cancelled or invalid file.',
                        ),
                        backgroundColor: success ? profitColor : Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildListTile(
                context,
                'App Info',
                Icons.info_outline_rounded,
                onTap: () => Navigator.pushNamed(context, '/appInfo'),
              ),
              const SizedBox(height: 10),
              _buildListTile(
                context,
                'Terms & Conditions',
                Icons.description_outlined,
                onTap: () =>
                    Navigator.pushNamed(context, '/termsAndConditions'),
              ),
              const SizedBox(height: 10),
              _buildListTile(
                context,
                'Privacy Policy',
                Icons.lock_outline_rounded,
                onTap: () => Navigator.pushNamed(context, '/privacyPolicy'),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Version $_version',
                  style: TextStyle(
                    fontSize: 13,
                    color: context.isDarkMode
                        ? lightGrayText
                        : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  void _showMonthlyCycleDialog(
    BuildContext context,
    ExpenseProvider expenseProvider,
  ) {
    int tempSelectedDay = expenseProvider.cycleStartDay;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = context.isDarkMode;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: softBlue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: softBlue,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Monthly Cycle',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select the day when your monthly cycle starts and resets in homepage',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? lightGrayText : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: tempSelectedDay,
                        isExpanded: true,
                        dropdownColor: isDark
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                        items: List.generate(31, (index) {
                          final day = index + 1;
                          final cycleText = MonthlyCycleHelper.getCycleLabel(
                            day,
                          );
                          final label = day == 5
                              ? '$cycleText (Default: Day 5)'
                              : cycleText;
                          return DropdownMenuItem<int>(
                            value: day,
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: day == tempSelectedDay
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: day == tempSelectedDay
                                    ? softBlue
                                    : (isDark ? lightColor : darkGray),
                              ),
                            ),
                          );
                        }),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              tempSelectedDay = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: isDark ? lightGrayText : Colors.grey.shade600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    await expenseProvider.setCycleStartDay(tempSelectedDay);
                    if (context.mounted) {
                      final cycleRangeText = MonthlyCycleHelper.getCycleLabel(
                        tempSelectedDay,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Monthly cycle set to $cycleRangeText'),
                          backgroundColor: softBlue,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: softBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    IconData leadingIcon, {
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.isDarkMode
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 2.0,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: softBlue.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(leadingIcon, color: softBlue, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: context.isDarkMode
                      ? lightGrayText
                      : Colors.grey.shade600,
                ),
              )
            : null,
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: context.isDarkMode ? lightGrayText : Colors.grey.shade500,
        ),
        onTap: onTap,
      ),
    );
  }
}
