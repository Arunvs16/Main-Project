import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CroppedImage extends StatelessWidget {
  final CroppedFile image;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  CroppedImage({
    super.key,
    required this.image,
  });

  final TextEditingController captionController = TextEditingController();

  Future<void> uploadImageAndCaption(BuildContext context) async {
    try {
      isLoading.value = true;

      // Initialize Firebase
      await Firebase.initializeApp();

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
      await FirebaseFirestore.instance.collection('Posts').add({
        'imageUrl': downloadUrl,
        'caption': captionController.text,
        'timestamp': Timestamp.now(),
        'userId': user.uid,
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: Text(
            'Image uploaded successfully!',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
      );
      print('Image uploaded successfully!');

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
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Cropped Image"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                uploadImageAndCaption(context).whenComplete(() {
                  Navigator.pop(context);
                });
              },
              child: ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (context, value, child) {
                  return value
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.surface,
                        )
                      : Text(
                          'Upload',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.bold),
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
