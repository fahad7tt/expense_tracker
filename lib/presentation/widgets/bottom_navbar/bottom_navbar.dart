import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/constants/constants.dart';
import '../../pages/add_expense/add_expense_page.dart';
import '../../providers/navigation_provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            BottomAppBar(
              color: lightColor,
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
                      // Clear the navigation stack and navigate to the home page
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
            Positioned(
              bottom: 12,
              right: 20,
              child: Transform.scale(
                scale: 1.0, // Scale factor for the FAB size
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddExpensePage(),
                      ),
                    );
                  },
                  splashColor: navbarColor,
                  tooltip: 'Add Expense',
                  child: const Icon(Icons.add),
                ),
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
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: navProvider.selectedIndex == index
                  ? selectedIconColor
                  : darkColor,
              size: homeIcon,
            ),
            Text(
              label,
              style: TextStyle(
                color: navProvider.selectedIndex == index
                    ? selectedIconColor
                    : deepBlue,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
