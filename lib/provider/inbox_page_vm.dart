import 'package:flutter/material.dart';

class InboxPageVm with ChangeNotifier {
  String _inputText = "";

  String get inputText {
    return _inputText;
  }

  void setInputText(String str) {
    _inputText = "";
    _inputText = str;
    notifyListeners();
  }
}
