import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:szaman_chat/data/repositories/auth_repos.dart';

class AuthVm with ChangeNotifier {
  bool _isLoading = false;

  File? _storedImage;

  File? get storedImage {
    return _storedImage;
  }

  bool get isLoading {
    return _isLoading;
  }

  void setStoreImage(File? stImage) {
    _storedImage = stImage;
    notifyListeners();
  }

  void setIsLoading(bool isLoad) {
    _isLoading = isLoad;
    notifyListeners();
  }

  String _token = "";
  DateTime _expiryDate = DateTime(0);
  String _userId = "";
  String _refreshToken = "";
  Timer _authTimer = Timer(Duration.zero, () {});

  final AuthRepos _authRepos = AuthRepos();

  bool get isAuth {
    return token.isNotEmpty;
  }

  String get userId {
    return _userId;
  }

  String get token {
    return _token;
  }

  DateTime get expiryDate {
    return _expiryDate;
  }

  String get refreshToken {
    return _refreshToken;
  }

  Future<bool> signup(
      String email, String password, String name, File? file) async {
    try {
      final authData =
          await _authRepos.authenticate(email, password, 'signUp', name, file);

      print("authData: $authData");

      _token = authData['token'];
      _expiryDate = DateTime.parse(authData['expiryDate']);
      _userId = authData['userId'];
      _refreshToken = authData['refreshToken'];

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final authData =
          await _authRepos.authenticate(email, password, 'signInWithPassword');
      _token = authData['token'];
      _expiryDate = DateTime.parse(authData['expiryDate']);
      _userId = authData['userId'];
      _refreshToken = authData['refreshToken'];

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepos.logout();
    _token = "";
    _userId = "";
    _expiryDate = DateTime(0);
    _refreshToken = "";

    if (_authTimer != Timer(Duration.zero, () {})) {
      _authTimer.cancel();
      _authTimer = Timer(Duration.zero, () {});
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final authData = await _authRepos.tryAutoLogin();
    if (authData != null) {
      _token = authData['token']!;
      _userId = authData['userId']!;
      _refreshToken = authData['refreshToken']!;
      _expiryDate = DateTime.parse(authData['expiryDate']);

      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }
}
