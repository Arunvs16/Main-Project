import 'package:flutter/material.dart';
import 'package:main_project/Providers/pages_provider.dart';
import 'package:main_project/components/bottom_nav_bar.dart';
import 'package:main_project/pages/home_page.dart';
import 'package:main_project/pages/pick_image_page.dart';
import 'package:main_project/pages/profile_page.dart';
import 'package:main_project/pages/search_page.dart';
import 'package:main_project/services/auth_service.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

// access auth

  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(),
      SearchPage(),
      PicImagePage(),
      ProfilePage(
        uid: _auth.getCurrentUserUid(),
      ),
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
