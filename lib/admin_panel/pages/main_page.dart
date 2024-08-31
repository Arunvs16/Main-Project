import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/admin_panel/pages/Posts_page.dart';
import 'package:main_project/admin_panel/pages/users_page.dart';
import 'package:main_project/pages/auth/auth_page.dart';
import 'package:main_project/services/auth_service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AdminMainPage extends StatelessWidget {
  AdminMainPage({super.key});

  // intsance of auth page
  // final AdminAuthPage _authPage = AdminAuthPage();

  final _auth = AuthService();

  void logOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Text(
          'Do you want to logout of Admin account?',
          style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          MaterialButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          MaterialButton(
            child: Text(
              'Logout',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onPressed: () {
              _auth.logout().whenComplete(
                () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        child: AuthPage(),
                        type: PageTransitionType.bottomToTop,
                        duration: Durations.long1,
                      ),
                      (context) => false);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Welcome Admin"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () => logOut(context),
            child: Text(
              "Logout",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              logOut(context);
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Users
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: UsersPage(),
                    type: PageTransitionType.rightToLeft,
                  ),
                );
              },
              child: Container(
                width: 300,
                height: 100,
                margin: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Users',
                    style: TextStyle(
                      fontSize: 24,
                      color: isDarkMode
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),

            // Posts
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: PostsPage(),
                    type: PageTransitionType.rightToLeft,
                  ),
                );
              },
              child: Container(
                width: 300,
                height: 100,
                margin: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Posts',
                    style: TextStyle(
                      fontSize: 24,
                      color: isDarkMode
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),

            // Comments
            Container(
              width: 300,
              height: 100,
              margin: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 24,
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.inversePrimary
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),

            // Chat
            Container(
              width: 300,
              height: 100,
              margin: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 24,
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.inversePrimary
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),

            // dark mode
            GestureDetector(
              onTap: () => Provider.of<ThemeProvider>(context, listen: false)
                  .toggleTheme(),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.symmetric(horizontal: 55),
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // dark mode text
                    Text("Dark Mode"),

                    //cupertino switch
                    CupertinoSwitch(
                      activeColor: Theme.of(context).colorScheme.error,
                      value: Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkMode,
                      onChanged: (value) =>
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
