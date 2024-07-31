import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:main_project/model/post_model.dart';

class StorageProvider with ChangeNotifier {
  final postsCollection = FirebaseFirestore.instance.collection("posts");
  Future<void> fetchPost() async {
    var snapshot = await postsCollection.get();
    var posts = snapshot.docs.map((doc) => PostModel.fromJson);
    notifyListeners();
  }

  Future<void> addPostToStorage(PostModel post, File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("post images")
        .child("${post.imageURL}.jpg");
    await storageRef.putFile(image);
    final imageUrl = await storageRef.getDownloadURL();

    final newPost = PostModel(
      userName: post.userName,
      userEmail: post.userEmail,
      userID: post.userID,
      caption: post.caption,
      postID: post.postID,
      imageURL: imageUrl,
      like: post.like,
    );
    await postsCollection.add(newPost.toMap());
    fetchPost();
  }
}
