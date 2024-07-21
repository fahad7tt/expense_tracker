import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/utils/constants/constants.dart';
import 'package:provider/provider.dart';
import '../../pages/add_expense_page.dart';
import '../../providers/navigation_provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, child) {
        return Stack(
          clipBehavior: Clip.none,
          children:[
           BottomAppBar(
            color: navbarColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                  Icons.home_rounded,
                  color: darkColor,
                  size: iconSize),
                  onPressed: () {
                    navProvider.setIndex(0);
                  },
                ),
                IconButton(
                  icon: const Icon(
                  Icons.summarize_rounded,
                  color: darkColor,
                  size: iconSize),
                  onPressed: () {
                    navProvider.setIndex(1);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person,
                  color: darkColor,
                  size: iconSize),
                  onPressed: () {
                    navProvider.setIndex(2);
                  },
                ),
                const SizedBox(width: 48), // Space for the FAB
              ],
            ),
                     ),
          Positioned(
          bottom: 12,
          right: 16,
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
}
