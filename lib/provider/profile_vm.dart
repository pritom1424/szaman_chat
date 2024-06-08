import 'package:flutter/material.dart';

class ProfileVm with ChangeNotifier {
  bool _isEditMode = false;

  bool get isEditMode {
    return _isEditMode;
  }

  void setEditBool(bool isEd) {
    _isEditMode = isEd;
    notifyListeners();
  }
}
