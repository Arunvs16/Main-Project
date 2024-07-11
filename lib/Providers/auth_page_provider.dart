import 'package:flutter/material.dart';

class AuthPageProvider extends ChangeNotifier {
  // initially show login page

  bool _showLoginPage = true;

  bool get showLoginPage => _showLoginPage;

  void togglePage() {
    _showLoginPage = !_showLoginPage;
    notifyListeners();
  }
}
