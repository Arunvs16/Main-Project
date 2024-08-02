import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_text_box.dart';
import 'package:main_project/pages/open_post_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(currentUser.uid)
                  .snapshots(),
              // userDataProvider.documentStream,
              builder: (context, snapshot) {
                // get user data
                if (snapshot.hasData) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // User Profile pic
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 5,
                              color: isDarkMode
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : Theme.of(context).colorScheme.primary),
                        ),
                        child: ClipRRect(
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
                      ),
                      const SizedBox(height: 10),

                      // username
                      Text(
                        '@${userData['username']}',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Edit profile button
                      Center(
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Theme.of(context).colorScheme.primary),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // bio
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        margin: EdgeInsets.only(left: 20, top: 20, right: 20),
                        padding: EdgeInsets.only(left: 20, bottom: 20, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // bio header
                                Text(
                                  'Bio',
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? Theme.of(context)
                                              .colorScheme
                                              .inversePrimary
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),

                                // edit icon
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.edit,
                                        color: Colors.transparent))
                              ],
                            ),
                            // bio
                            Text(
                              userData['bio'],
                              style: TextStyle(
                                  color: isDarkMode
                                      ? Theme.of(context)
                                          .colorScheme
                                          .inversePrimary
                                      : Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  displayMessageToUser("Error+ ${snapshot.error}", context);
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            // my post header
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                'Uploads',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            // my posts
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(currentUser.uid)
                  .collection("Posts")
                  .snapshots(),
              builder: (context, snapshot) {
                // show errors
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                // show loading circle
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }
                // get all posts
                final posts = snapshot.data!.docs;
                // no data
                if (snapshot.data == null || posts.isEmpty) {
                  return Container();
                }
                // return as a Grid view
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    crossAxisCount: 3,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // get each individual post
                    final post = posts[index];
                    // get data from each post
                    String imageUrl = post['imageUrl'];

                    // return as a container
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: OpenPostPage(),
                            type: PageTransitionType.fade,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Image.network(
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              child: Icon(Icons.error_outline),
                            );
                          },
                          imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
