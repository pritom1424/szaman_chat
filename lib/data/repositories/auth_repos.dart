import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:szaman_chat/utils/constants/app_paths.dart';

class AuthRepos {
  String _refreshToken = "";
  Timer _authTimer = Timer(Duration.zero, () {});
  final _params = {
    'key': 'AIzaSyA1Hortv46XM9Nc8QummVhoqa3JWBycHJY',

    // Replace with your actual API key
  };
/*   String _token = "";
  DateTime _expiryDate = DateTime(0);
  String _userId = "";
  String _refreshToken = "";
  Timer _authTimer = Timer(Duration.zero, () {});
  bool get isAuth {
    return token.isNotEmpty;
  } */

/*   String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    _refreshTokenIfNeeded();
    return "";
  } */

  Future<Map<String, dynamic>> authenticate(
      String email, String password, String urlSegment,
      [String? name, File? imageFile, bool isAdmin = false]) async {
    final url = Uri.https(
      "identitytoolkit.googleapis.com",
      "/v1/accounts:$urlSegment",
      _params,
    );

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = jsonDecode(response.body);

      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }

      final params = {'auth': responseData['idToken']};

      await _addInfoTOServer(name, responseData['localId'], imageFile, email,
          isAdmin, responseData['idToken'], params);

      final prefs = await SharedPreferences.getInstance();
      final expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );
      final data = {
        'token': responseData['idToken'],
        'userId': responseData['localId'],
        'expiryDate': expiryDate.toIso8601String(),
        'refreshToken': responseData['refreshToken'],
      };
      _autoLogout(expiryDate);
      final userData = json.encode(data);
      prefs.setString('userData', userData);
      return data;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _addInfoTOServerUpdateToken(
      String idToken, String userId, Map<String, dynamic> params) async {
    final link = Uri.https('szaman-chat-default-rtdb.firebaseio.com',
        '/users/$userId.json', params);

    await http.patch(link, body: json.encode({"token": idToken}));
  }

  Future<void> _addInfoTOServer(
      String? username,
      String userId,
      File? imageFile,
      String email,
      bool isAdmin,
      String token,
      Map<String, dynamic> params) async {
    if (username != null) {
      final link = Uri.https('szaman-chat-default-rtdb.firebaseio.com',
          '/users/$userId.json', params);

      final ref =
          FirebaseStorage.instanceFor(bucket: "gs://szaman-chat.appspot.com")
              .ref()
              .child('profile_images')
              .child(userId) //responseData['localId']
          ;
      // await ref.putFile(imageFile);
      if (imageFile != null) {
        await ref.putFile(imageFile);
      } else {
        final ByteData byteData =
            await rootBundle.load(AppPaths.charplaceholderPath);
        final Uint8List imageData = byteData.buffer.asUint8List();

        await ref.putData(imageData);
      }
      final durl = await ref.getDownloadURL();

      print("profile name update: $username");
      final response = await http.put(link,
          body: json.encode({
            "creatorId": DateTime.now().toIso8601String(),
            "email": email,
            "imageUrl": durl,
            "isAdmin": isAdmin,
            "name": username,
            "token": token
          }));
      print(
          "profile name update: ${response.statusCode}: ${json.decode(response.body)}");
    } else {
      if (token.isNotEmpty && userId.isNotEmpty) {
        final params = {'auth': token};
        await _addInfoTOServerUpdateToken(token, userId, params);
      }
    }
  }

  Future<void> logout() async {
    /*   _token = "";
    _userId = "";
    _expiryDate = DateTime(0);
    _refreshToken = "";
    if (_authTimer != Timer(Duration.zero, () {})) {
      _authTimer.cancel();
      _authTimer = Timer(Duration.zero, () {});
    }
 */
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<Map<String, dynamic>?> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return null;
    }
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiryDate'] as String);
    _refreshToken = extractedData['refreshToken'];

    if (expiryDate.isBefore(DateTime.now())) {
      final data = await _refreshTokenIfNeeded();
      final date = DateTime.parse(data['expiryDate']);
      final params = {'auth': extractedData['token']};
      await _addInfoTOServerUpdateToken(
          extractedData['token'], extractedData['userId'], params);
      _autoLogout(date);
      return data;
    } else {
      final params = {'auth': extractedData['token']};
      await _addInfoTOServerUpdateToken(
          extractedData['token'], extractedData['userId'], params);
      _autoLogout(expiryDate);
      return extractedData;
    }

/*     UserCredential.token = _token;
    UserCredential.userId = _userId;
    UserCredential.refreshToken = _refreshToken;
    UserCredential.expiryDate = _expiryDate; */
  }

  Future<Map<String, dynamic>> _refreshTokenIfNeeded() async {
    if (_refreshToken.isEmpty) {
      return {};
    }
    final url = Uri.parse(
        'https://securetoken.googleapis.com/v1/token?key=${_params['key']}');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'grant_type': 'refresh_token',
          'refresh_token': _refreshToken,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }
/*       _token = responseData['id_token'];
      _refreshToken = responseData['refresh_token'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expires_in'])),
      ); */
      final prefs = await SharedPreferences.getInstance();
      final data = {
        'token': responseData['idToken'],
        'userId': responseData['localId'],
        'expiryDate': DateTime.now()
            .add(Duration(seconds: int.parse(responseData['expiresIn'])))
            .toIso8601String(),
        'refreshToken': responseData['refreshToken'],
      };
      final userData = json.encode(data);
      prefs.setString('userData', userData);
      return data;
    } catch (error) {
      rethrow;
    }
  }

  void _autoLogout(DateTime expiryDate) {
    if (_authTimer != Timer(Duration.zero, () {})) {
      _authTimer.cancel();
    }
    final timeToExpiry = expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<Map<String, dynamic>> updateAccount(String token, String newEmail,
      String name, File? imageFile, bool isAdmin) async {
    final url = Uri.https(
      "identitytoolkit.googleapis.com",
      "/v1/accounts:update",
      {'auth': token, 'key': 'AIzaSyA1Hortv46XM9Nc8QummVhoqa3JWBycHJY'},
    );

    Map<String, dynamic> data = {};

    data = {'idToken': token, 'email': newEmail, 'returnSecureToken': true};

    try {
      final response = await http.post(
        url,
        body: json.encode(data),
      );
      final responseData = jsonDecode(response.body);

      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }

      final params = {'auth': responseData['idToken']};

      await _addInfoTOServer(name, responseData['localId'], imageFile, newEmail,
          isAdmin, token, params);

      // Update the email in the Realtime Database if necessary
      final prefs = await SharedPreferences.getInstance();
      final userData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
      userData['email'] = newEmail;
      prefs.setString('userData', json.encode(userData));

      return responseData;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteUser(String token, String userId) async {
    final params = {'auth': token};

    final url = Uri.https(
      "identitytoolkit.googleapis.com",
      "/v1/accounts:delete",
      _params,
    );
    final refr =
        FirebaseStorage.instanceFor(bucket: "gs://szaman-chat.appspot.com")
            .ref()
            .child('profile_images')
            .child(userId) //responseData['localId']
        ;

    try {
      //delete database of user
      final link = Uri.https('szaman-chat-default-rtdb.firebaseio.com',
          '/users/$userId.json', params);
      //delete cloud storage of user
      await http.delete(
        link,
      );
      await refr.delete();
      //delete auth id of user
      final response = await http.post(
        url,
        body: json.encode(
          {
            'key': 'AIzaSyA1Hortv46XM9Nc8QummVhoqa3JWBycHJY',
            'idToken': token,
          },
        ),
      );
      final responseData = jsonDecode(response.body);

      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }

      return true;
    } catch (error) {
      rethrow;
    }
  }
}
