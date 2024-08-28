import 'package:flutter/material.dart';
import 'package:main_project/model/user.dart';
import 'package:main_project/services/firestore.dart';

class UserProvider with ChangeNotifier {
  UserProfile? userModel;
  bool isLoad = true;

  getDetails() async {
    userModel = await Firestore().getUserDetails();
    isLoad = false;
    notifyListeners();
  }
}
