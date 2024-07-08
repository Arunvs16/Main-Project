import 'package:flutter/material.dart';

class PagesProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;
  
  void onTappedPage(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
