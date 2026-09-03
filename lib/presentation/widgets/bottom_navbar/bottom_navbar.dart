import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/theme/system_theme.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/constants/constants.dart';
import '../../pages/add_expense/add_expense_page.dart';
import '../../providers/navigation_provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navTheme = theme.bottomNavigationBarTheme;

    return Consumer<NavigationProvider>(
      builder: (context, navProvider, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: navTheme.backgroundColor,
                border: Border(
                  top: BorderSide(
                    color: context.isDarkMode
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    width: 1.0,
                  ),
                ),
              ),
              child: BottomAppBar(
                elevation: 0,
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildNavItem(
                      context,
                      icon: Icons.home_rounded,
                      label: 'Home',
                      index: 0,
                      navProvider: navProvider,
                      onTap: () {
                        navProvider.setIndex(0);
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/home', (route) => false);
                      },
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.summarize_rounded,
                      label: 'Summary',
                      index: 1,
                      navProvider: navProvider,
                      onTap: () {
                        navProvider.setIndex(1);
                        Navigator.pushNamed(context, '/summary');
                      },
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      index: 2,
                      navProvider: navProvider,
                      onTap: () {
                        navProvider.setIndex(2);
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    const SizedBox(width: 64),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 14,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddExpensePage(),
                    ),
                  );
                },
                tooltip: 'Add Expense',
                elevation: 4,
                child: const Icon(Icons.add_rounded, size: 28),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required NavigationProvider navProvider,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final navTheme = theme.bottomNavigationBarTheme;
    final isSelected = navProvider.selectedIndex == index;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? navTheme.selectedItemColor
                  : navTheme.unselectedItemColor,
              size: homeIcon,
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: TextStyle(
                color: isSelected
                    ? navTheme.selectedItemColor
                    : navTheme.unselectedItemColor,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
