import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:main_project/services/authentication.dart';
import 'package:main_project/utils/new_utils.dart';
import 'package:provider/provider.dart';

class FirebaseOperations with ChangeNotifier {
  UploadTask? imageUploadTask;

  Future uploadUserProfilePic(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
          'userProfilePic/${Provider.of<NewUtils>(context, listen: false).getUserProfilePic!.path}/${TimeOfDay.now()}',
        );
    imageUploadTask = imageReference.putFile(
      Provider.of<NewUtils>(context, listen: false).getUserProfilePic!,
    );
    await imageUploadTask!.whenComplete(() {
      print('Image Uploaded');
    });
    imageReference.getDownloadURL().then((url) {
      Provider.of<NewUtils>(context, listen: false).userProfilePicUrl =
          url.toString();
      print(
          'The user profile pic => ${Provider.of<NewUtils>(context, listen: false).userProfilePicUrl}');
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserUID)
        .set(data);
  }
}
