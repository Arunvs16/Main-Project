import 'dart:io';

import 'package:flutter/material.dart';
import 'package:main_project/Providers/authentication.dart';
import 'package:main_project/model/post_model.dart';
import 'package:provider/provider.dart';

class AddPostProvider with ChangeNotifier {
  File? image;
  File? get getImage => image;

  Future<void> addPost(
    BuildContext context,
    TextEditingController caption,
  ) async {
    if (caption.text.isNotEmpty) {
      final post = PostModel(
        id: TimeOfDay.now().toString(),
        userName: '',
        userEmail: '',
        userID: Provider.of<Authentication>(context).getUserUID.toString(),
        caption: caption.text,
        postID: '',
        imageURL: '',
        like: [],
      );
    }
  }
}
