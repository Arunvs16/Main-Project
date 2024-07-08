import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:main_project/Providers/pages_provider.dart';

class BottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  int selectedIndex;
  BottomNavBar({
    super.key,
    required this.onTabChange,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20,
        ),
        child: GNav(
          selectedIndex: selectedIndex,
          backgroundColor: Colors.black,
          gap: 10,
          activeColor: Theme.of(context).colorScheme.primary,
          color: Theme.of(context).colorScheme.primary,
          tabBackgroundColor: Theme.of(context).colorScheme.tertiary,
          padding: EdgeInsets.all(16),
          // provider
          onTabChange: onTabChange,
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.search,
              text: 'Search',
              onPressed: () {},
            ),
            GButton(
              icon: Icons.notifications,
              text: 'Notifications',
              onPressed: () {},
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
