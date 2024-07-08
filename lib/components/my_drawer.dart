import 'package:flutter/material.dart';
import 'package:main_project/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  void Function()? onTap;
  MyDrawer({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // drawer header
              //logo
              GestureDetector(
                onTap: onTap,
                child: Row(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 40,
                        child: Image.network(
                          "https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png",
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        // username
                        Text(
                          "Arun V S",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // email id
                        Text(
                          "avs4164@gmail.com",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // home list tile
              MyListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/mainpage');
                },
                horizontal: 25,
                vertical: 0,
                leading: Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.primary,
                ),
                titleText: "HOME",
                subTitleText: "Go back to home page",
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          // settings list tile
          MyListTile(
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
            horizontal: 25,
            vertical: 20,
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.primary,
            ),
            titleText: "SETTINGS",
            subTitleText: "Dark mode, Profile",
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
