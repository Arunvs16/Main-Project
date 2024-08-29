import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:main_project/Providers/user_provider.dart';
import 'package:main_project/model/post.dart';
import 'package:main_project/model/user.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddPostToFeed extends StatelessWidget {
  final CroppedFile image;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  AddPostToFeed({
    super.key,
    required this.image,
  });
  final TextEditingController captionController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;

  Future<void> uploadImageAndCaption(BuildContext context) async {
    String postId = Uuid().v1();
    try {
      isLoading.value = true;
      // Check if the user is authenticated
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: Text(
              'User is not authenticated',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
        );
        isLoading.value = false;
        return;
      }
      // Create a unique file name for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload image to Firebase Storage
      File imageFile = File(image.path);
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('images/$fileName.jpg')
          .putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Save the image URL and caption to Firestore
      final Timestamp timestamp = Timestamp.now();

      UserProfile? _user =
          Provider.of<UserProvider>(context, listen: false).userModel;

      PostData post = PostData(
        email: user.email.toString(),
        username: user.displayName.toString(),
        caption: captionController.text,
        postID: postId,
        imageURL: downloadUrl,
        timestamp: timestamp,
        likes: [],
      );
      // convert user into a map so that we can store in firestore
      final postMap = post.toMap();

      // save post into info in firestore
      await _firestore.collection("Posts").doc(postId).set(postMap);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          content: Text(
            'Image uploaded successfully!',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
      );
      print('Image uploaded successfully!');
      Navigator.pop(context);

      // Clear the caption controller
      captionController.clear();
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            'Error uploading image: $e',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Add Post"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                uploadImageAndCaption(context);
              },
              child: ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (context, value, child) {
                  return value
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : Text(
                          'Upload',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 1 / 3,
                  width: MediaQuery.of(context).size.height * 1 / 3,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Image(
                    image: FileImage(
                      File(image.path),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: MediaQuery.of(context).size.height * 1 / 4,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: TextField(
                    controller: captionController,
                    maxLines: 6,
                    maxLength: 250,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.secondary,
                      hintText: 'Add caption',
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
