import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:main_project/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class NewUtils with ChangeNotifier {
  final picker = ImagePicker();
  File? userProfilePic;
  File? get getUserProfilePic => userProfilePic;
  String? userProfilePicUrl;
  String? get getUserProfilePicUrl => userProfilePicUrl;

  // for picking image
  Future pickUserProfilePic(BuildContext context, ImageSource source) async {
    final pickedUserProfilePic = await picker.pickImage(source: source);
    pickedUserProfilePic == null
        ? print('Select image')
        : userProfilePic = File(pickedUserProfilePic.path);

    userProfilePic != null
        ? Provider.of<FirebaseOperations>(context, listen: false)
            .uploadUserProfilePic(context)
        : print('Image upload error');
    notifyListeners();
  }
}
