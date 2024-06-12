import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:szaman_chat/data/repositories/auth_repos.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';

class AuthVm with ChangeNotifier {
  bool _isLoading = false;

  File? _storedImage;
  bool _isAdmin = false;

  bool get isAdmin {
    return _isAdmin;
  }

  File? get storedImage {
    return _storedImage;
  }

  bool get isLoading {
    return _isLoading;
  }

  void setAdmin(bool didAdmin) {
    _isAdmin = didAdmin;
    notifyListeners();
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

  Future<bool> signup(String email, String password, String name, File? file,
      bool isAdmin) async {
    try {
      setIsLoading(true);
      final authData = await _authRepos.authenticate(
          email, password, 'signUp', name, file, isAdmin);
      setIsLoading(false);

      _token = authData['token'];
      _expiryDate = DateTime.parse(authData['expiryDate']);
      _userId = authData['userId'];
      _refreshToken = authData['refreshToken'];

      return true;
    } catch (e) {
      setIsLoading(false);
      print(e);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      setIsLoading(true);
      final authData =
          await _authRepos.authenticate(email, password, 'signInWithPassword');

      _token = authData['token'];
      _expiryDate = DateTime.parse(authData['expiryDate']);
      _userId = authData['userId'];
      _refreshToken = authData['refreshToken'];
      Usercredential.id = userId;
      Usercredential.token = _token;
      setIsLoading(false);
      return true;
    } catch (e) {
      setIsLoading(false);
      print(e);
      return false;
    }
  }

  Future<String> update(
      String token, String email, String name, File? imageFile) async {
    try {
      final authData = await _authRepos.updateAccount(
          token, email, name, imageFile, isAdmin);

      if (authData.isEmpty) {
        return "no data found";
      }
    } catch (err) {
      return err.toString();
    }

    return "info updated successfully";
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

      Usercredential.id = userId;
      Usercredential.token = _token;
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUser(String tk, String uId) async {
    final authData = await _authRepos.deleteUser(tk, uId);

    if (authData) {
      return true;
    } else {
      return false;
    }
  }
}
