import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/pages_provider.dart';
import 'package:main_project/components/my_drawer.dart';
import 'package:main_project/pages/chat_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //user
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final pagesProvider = Provider.of<PagesProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Icon(
          Icons.favorite,
          color: Theme.of(context).colorScheme.primary,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(),
                ),
              );
            },
            icon: Icon(Icons.message_outlined),
          )
        ],
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/comments');
            },
            icon: Icon(Icons.comment),
          ),
        ],
      ),
    );
  }
}
