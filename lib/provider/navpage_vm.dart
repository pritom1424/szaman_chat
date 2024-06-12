import 'package:flutter/material.dart';

class NavpageViewModel with ChangeNotifier {
  int _selectedIndex = 0;

  bool _isInit = false;

  void setIndex(int ind) {
    _selectedIndex = ind;
    notifyListeners();
  }

  void setIsInit(bool ini) {
    _isInit = ini;
    //  notifyListeners();
  }

  int get selectIndex {
    return _selectedIndex;
  }

  bool get isInit {
    return _isInit;
  }
}
