import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:szaman_chat/data/repositories/auth_repos.dart';
import 'package:szaman_chat/main.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';

class AuthVm with ChangeNotifier {
  TextEditingController? _nametextEditingController;

  TextEditingController get nameController {
    _nametextEditingController ??= TextEditingController();
    return _nametextEditingController!;
  }

  TextEditingController? _mobiletextEditingController;

  TextEditingController get mobileController {
    _mobiletextEditingController ??= TextEditingController();
    return _mobiletextEditingController!;
  }

  TextEditingController? _otptextEditingController;

  TextEditingController get optController {
    _otptextEditingController ??= TextEditingController();
    return _otptextEditingController!;
  }

  bool _isLoading = false;

  List<dynamic> signData = [];

  bool _isMessageSent = false;

  File? _storedImage;
  bool _isAdmin = false;

  bool get isAdmin {
    return _isAdmin;
  }

  bool get isMessageSent {
    return _isMessageSent;
  }

  File? get storedImage {
    return _storedImage;
  }

  bool get isLoading {
    return _isLoading;
  }

  void resetAuthForm() {
    _isMessageSent = false;
    _storedImage = null;
    _isLoading = false;
    _otptextEditingController?.clear();
    _nametextEditingController?.clear();
    _mobiletextEditingController?.clear();
    notifyListeners();
  }

  void setAdmin(bool didAdmin) {
    _isAdmin = didAdmin;
    notifyListeners();
  }

  void setMessageSent(bool didSend) {
    _isMessageSent = didSend;
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

  /* Future<bool> signup(String email, String password, String name, File? file,
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
  } */

  /* Future<bool> login(String phoneNumber, String password) async {
    try {
      setIsLoading(true);
      final authData = await _authRepos.authenticate(
          phoneNumber, password, 'signInWithPassword');

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
  } */

//this
  Future<bool> verifySignIn(List<dynamic> data, String otpCode, String userName,
      File? imageFile, bool isAdmin, String phoneNumber) async {
    try {
      if (data[0] != null && data[1] != null) {
        await _authRepos.verifyOtp(data[0].toString(), otpCode, userName,
            imageFile, isAdmin, phoneNumber);

        Usercredential.id = auth.currentUser?.uid;
        Usercredential.isAdmin = isAdmin;
        Usercredential.name = auth.currentUser?.displayName;
        Usercredential.token = await auth.currentUser?.getIdToken();

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

//this
  Future<List<dynamic>> signin(String phoneNumber) async {
    try {
      final List<dynamic> data =
          await _authRepos.signInWithPhoneNumber(phoneNumber);

      return data;
    } catch (e) {
      return [];
    }
  }

  Future<String> update(String token, String name, File? imageFile) async {
    try {
      if (Usercredential.id == null) {
        return "info update failed!";
      }
      final authData = await _authRepos.updateAccount(
          token, name, Usercredential.id!, imageFile, isAdmin);
      if (authData == null || authData == false) {
        return "info update failed!";
      }
      return "info updated successfully!";
    } catch (err) {
      return err.toString();
    }
  }

  Future<void> logout() async {
    await _authRepos.logout();
    _token = "";
    _userId = "";
    _expiryDate = DateTime(0);
    _refreshToken = "";

    _isLoading = false;
    _isMessageSent = false;
    _isAdmin = false;
    _storedImage = null;
    await auth.signOut();

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
    print("auth data $authData");
    if (authData != null) {
      print("authentic data $authData");
      _token = authData['token']!;
      _userId = authData['id'];
      //_refreshToken = authData['refreshToken']!;
      _expiryDate = DateTime.parse(authData['expiryDate']);

      Usercredential.id = userId;
      Usercredential.token = _token;
      //await auth.signInWithCustomToken()
      notifyListeners();
      return true;
    } else {
      print("auth data ${auth.currentUser?.uid ?? "null"}");

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
