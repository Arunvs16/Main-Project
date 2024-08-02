import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/components/user_tile.dart';
import 'package:main_project/pages/chat_page.dart';
import 'package:main_project/services/chat_services.dart';
import 'package:page_transition/page_transition.dart';

class ChatListPage extends StatelessWidget {
  ChatListPage({super.key});

  // chat service and auth
  final ChatService _chatService = ChatService();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Chats"),
      ),
      body: _buildUserList(),
    );
  }

  // build a users list except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // has no data
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print("No data found");
          return Center(
            child: Text('No users'),
          );
        }

        // debug: print the received user data
        print("Received user data: ${snapshot.data}");

        // has data
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // build individual list tile for users
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // debug: print individual user data
    print("User Data -> $userData");

    // display all the users except current user
    return FutureBuilder(
      future: _chatService.getLastMessage(userData['uid']),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return ListTile(
            title: Text(userData['username']),
            subtitle: Text('Error loading last message'),
          );
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            title: Text(userData['username']),
            subtitle: Text('Loading...'),
          );
        }

        // has data
        String lastMessage = snapshot.data ?? 'No messages';

        return UserTile(
          username: userData['username'],
          text: lastMessage,
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                child: ChatPage(
                  receiverId: userData['uid'],
                  receiverEmail: userData['username'],
                ),
                type: PageTransitionType.fade,
              ),
            );
          },
        );
      },
    );
  }
}
