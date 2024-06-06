import 'package:flutter/material.dart';

class NavpageViewModel with ChangeNotifier {
  int _selectedIndex = 0;

  void setIndex(int ind) {
    _selectedIndex = ind;
    notifyListeners();
  }

  int get selectIndex {
    return _selectedIndex;
  }
}
