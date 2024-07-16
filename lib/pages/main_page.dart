import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/pages_provider.dart';
import 'package:main_project/components/bottom_nav_bar.dart';
import 'package:main_project/pages/add_post_page.dart';
import 'package:main_project/pages/home_page.dart';
import 'package:main_project/pages/profile_page.dart';
import 'package:main_project/pages/search_page.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(),
      SearchPage(),
      AddPostPage(),
      ProfilePage(),
    ];
    final pagesProvider = Provider.of<PagesProvider>(context);
    return Scaffold(
      body: pages[pagesProvider.selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: pagesProvider.selectedIndex,
        onTabChange: (index) {
          pagesProvider.onTappedPage(index);
        },
      ),
    );
  }
}
