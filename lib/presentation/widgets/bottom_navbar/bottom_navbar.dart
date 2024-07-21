import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:provider/provider.dart';
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
              color: navbarColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildNavItem(
                    context,
                    icon: Icons.home_filled,
                    label: 'Home',
                    index: 0,
                    navProvider: navProvider,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.summarize_rounded,
                    label: 'Summary',
                    index: 1,
                    navProvider: navProvider,
                  ),
                 
                  _buildNavItem(
                    context,
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    index: 2,
                    navProvider: navProvider,
                  ),
                   const SizedBox(width: 64), // Placeholder for the FAB
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

  Widget _buildNavItem(BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required NavigationProvider navProvider,
  }) {
    return GestureDetector(
      onTap: () {
        navProvider.setIndex(index);
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: darkColor,
              size: iconSize,
            ),
            Text(
              label,
              style: const TextStyle(color: deepBlue, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
