import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class AuthRepos {
  String _refreshToken = "";
  Timer _authTimer = Timer(Duration.zero, () {});
  final _params = {
    'key': 'YOUR_FIREBASE_API_KEY',
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
      String email, String password, String urlSegment) async {
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
      _autoLogout(date);
      return data;
    } else {
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
}
