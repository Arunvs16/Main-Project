import 'package:flutter/foundation.dart';
import 'package:main_project/model/user_model.dart';
import 'package:main_project/services/authentication.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  bool isLoad = true;

  getDetails() async {
    userModel = await AuthMethods().getUserDetails();
    isLoad = false;
    notifyListeners();
  }
}


