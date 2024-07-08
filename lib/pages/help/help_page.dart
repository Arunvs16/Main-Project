import 'package:flutter/material.dart';
import 'package:main_project/components/my_list_tile.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Help"),
      ),
      body: Column(
        children: [
          // terms of services
          MyListTile(
            onTap: () {
              Navigator.pushNamed(context, '/termsOfServices');
            },
            horizontal: 10,
            vertical: 0,
            leading: Icon(
              Icons.help,
              color: Theme.of(context).colorScheme.primary,
            ),
            titleText: "Terms of Serices",
            subTitleText: "About our services",
            color: Theme.of(context).colorScheme.primary,
          ),

          // Privacy Policy
          MyListTile(
            onTap: () {
              Navigator.pushNamed(context, '/PrivacyPolicy');
            },
            horizontal: 10,
            vertical: 0,
            leading: Icon(
              Icons.privacy_tip_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            titleText: "Privacy Polocy",
            subTitleText: "End-to-end Encryption",
            color: Theme.of(context).colorScheme.primary,
          ),

          //app info
          MyListTile(
            onTap: () {
              Navigator.pushNamed(context, '/appInfo');
            },
            horizontal: 10,
            vertical: 0,
            leading: Icon(
              Icons.info,
              color: Theme.of(context).colorScheme.primary,
            ),
            titleText: "App Info",
            subTitleText: "About the app",
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
