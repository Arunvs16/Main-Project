import 'package:flutter/material.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_list_tile.dart';
import 'package:main_project/services/auth_service.dart';
import 'package:main_project/services/chat_services.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // chat service and auth
    final ChatService chatService = ChatService();

    final AuthService auth = AuthService();

    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    // delete user
    void deleteUser(BuildContext context, String userId) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: Text(
            'Do you want to delete this account?',
            style: TextStyle(
                fontSize: 24, color: Theme.of(context).colorScheme.primary),
          ),
          actions: [
            MaterialButton(
              color: Theme.of(context).colorScheme.secondary,
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {
                // pop
                close(context);
              },
            ),
            MaterialButton(
              color: Theme.of(context).colorScheme.error,
              child: Text(
                'Delete',
                style: TextStyle(
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () async {
                // delete account user
                await AuthService().deleteUser(userId).whenComplete(
                  () {
                    // pop
                    close(context);
                  },
                );
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("All Users"),
      ),
      body: StreamBuilder(
        stream: chatService.getUsersStream(),
        builder: (context, snapshot) {
          // error
          if (snapshot.hasError) {
            displayMessageToUser("Something went wrong", context);
          }

          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            );
          }

          // no data
          if (snapshot.data == null) {
            return Text("No Users");
          }

          // get all data
          final users = snapshot.data!;
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                // get individual user
                final user = users[index];
                return MyListTile(
                  onTap: () {
                    deleteUser(context, user['uid']);
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage('images/person.jpg'),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, object, stack) {
                        return Container(
                          child: Icon(Icons.error_outline),
                        );
                      },
                    ),
                  ),
                  titleText: user['username'],
                  subTitleText: user['email'],
                  horizontal: 0,
                  vertical: 5,
                  color1: isDarkMode
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.primary,
                  color2: isDarkMode
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.primary,
                );
              },
            );
          } else {
            return Text('No data found');
          }
        },
      ),
    );
  }
}
