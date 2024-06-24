import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:szaman_chat/main.dart';
import 'package:szaman_chat/utils/constants/app_paths.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';

class AuthRepos {
  final String _refreshToken = "";
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

  /* Future<List<dynamic>> signInWithPhoneNumber(String phoneNumber) async {
    String? verId;
    int? resToken;
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
/*         // await _storeUserData();
        print("credVErComp ${credential.smsCode}");
        final cred = await auth.signInWithCredential(credential); */
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.toString());
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
        resToken = resendToken;
        print("vm test rep $verificationId");

        // Handle the code sent logic here (Save verificationId if needed)
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    if (verId != null) {
      print("vm test repl $verId");
      return [verId, resToken];
    } else {
      return [];
    }
  } */
  //this
  Future<List<dynamic>> signInWithPhoneNumber(String phoneNumber) async {
    String? verificationId;
    int? resendToken;

    // Initialize the completer to wait for the codeSent callback
    final completer = Completer<List<dynamic>>();

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant validation
        try {
          final userCredential = await auth.signInWithCredential(credential);
          print("Verification completed: ${userCredential.user?.uid}");
        } catch (e) {
          print("Error in verificationCompleted: $e");
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: $e");
        completer.completeError(e);
      },
      codeSent: (String verId, int? resToken) {
        verificationId = verId;
        resendToken = resToken;
        print("Verification code sent: $verId");
        // Complete the completer with verificationId and resendToken
        completer.complete([verificationId.toString(), resendToken]);
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        print("Code auto-retrieval timeout: $verId");
      },
    );

    // Await the completer to return verificationId and resendToken
    return completer.future;
  }

//this
  Future<UserCredential?> verifyOtp(
      String verificationId,
      String otpCode,
      String userName,
      File? imageFile,
      bool isAdmin,
      String phoneNumber) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      final userInfo = await auth.signInWithCredential(credential);
      if (userInfo.user != null) {
        // Update display name
        await userInfo.user!.updateDisplayName(userName);
        await userInfo.user!
            .reload(); // Reload the user to ensure the display name is updated
        final token = await userInfo.user!.getIdToken();
        print("userinfo updated");
        final params = {"auth": token};
        await _addInfoTOServer(
            auth.currentUser?.displayName,
            userInfo.user!.uid,
            imageFile,
            phoneNumber,
            isAdmin,
            token!,
            params);
        _storeUserData();

        print(
            "Compare UserInfo ${userInfo.user!.displayName} <--> ${auth.currentUser?.displayName ?? "no name"}");
        return userInfo;
      }
    } catch (e) {
      print('Error in verifying OTP: $e');
      return null;
    }
    return null;
  }

// will store to shared preferences
  Future<void> _storeUserData() async {
    final User? user = auth.currentUser;
    if (user != null) {
      final idTokenResult = await user.getIdTokenResult();
      final refreshToken = user.refreshToken;
      final expiryDate = idTokenResult.expirationTime;

      final prefs = await SharedPreferences.getInstance();

      final data = {
        'id': user.uid,
        'token': idTokenResult.token,
        'expiryDate':
            expiryDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'refreshToken': refreshToken,
      };
      prefs.setString('userData', json.encode(data));
    }
  }

  /* Future<Map<String, dynamic>> authenticate(
      String phoneNumber, String urlSegment,
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
            'phoeneNumber': phoneNumber,
            'temporaryProof': true,
          },
        ),
      );
      final responseData = jsonDecode(response.body);
      print("responseData: $responseData");

      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }

      final params = {'auth': responseData['idToken']};

      await _addInfoTOServer(name, responseData['localId'], imageFile,
          phoneNumber, isAdmin, responseData['idToken'], params);

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
      final userData = json.encode(data);
      prefs.setString('userData', userData);
      return data;
    } catch (error) {
      rethrow;
    }
  } */

  Future<void> _addInfoTOServerUpdateToken(
      String idToken, String userId, Map<String, dynamic> params) async {
    print("before update token");
    final link = Uri.https('szaman-chat-default-rtdb.firebaseio.com',
        '/users/$userId.json', params);
    print("before patch");
    await http.patch(link, body: json.encode({"token": idToken}));
  }

  Future<void> _addInfoTOServer(
      String? username,
      String userId,
      File? imageFile,
      String phoneNumber,
      bool isAdmin,
      String token,
      Map<String, dynamic> params) async {
    if (username != null) {
      final link = Uri.https('szaman-chat-default-rtdb.firebaseio.com',
          '/users/$userId.json', params);
      print("user ID Login $userId");
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
            "phone": phoneNumber,
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
    //print("extract data ${prefs.getString('userData')!}");

    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

    print("extract data $extractedData");
    final expiryDate = DateTime.parse(extractedData['expiryDate'] as String);
    //_refreshToken = extractedData['refreshToken'];
    print("isexpired:${expiryDate.isBefore(DateTime.now())}");
    if (expiryDate.isBefore(DateTime.now())) {
      final data = await _refreshTokenIfNeeded();

      final date = DateTime.parse(data['expiryDate'].toString());
      final params = {'auth': extractedData['token']};
      await _addInfoTOServerUpdateToken(
          extractedData['token'], extractedData['userId'], params);
      //_autoLogout(date);
      return data;
    } else {
      final params = {'auth': extractedData['token']};

      print("before update token" + extractedData.toString());
      await _addInfoTOServerUpdateToken(
          extractedData['token'], extractedData['id'], params);
      print("before update token");
      // _autoLogout(expiryDate);
      return extractedData;
    }
    //  return extractedData;

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
        'id': responseData['localId'],
        'expiryDate': DateTime.now()
            .add(Duration(seconds: int.parse(responseData['expiresIn'])))
            .toIso8601String(),
        'refreshToken': responseData['refreshToken'],
      };
      final userData = json.encode(data);
      prefs.setString('userData', userData);
      return data;
    } catch (error) {
      print("refresh token ${error}");
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

  Future<bool?> updateAccount(String token, String phonenumber, String name,
      File? imageFile, bool isAdmin) async {
    /*  final url = Uri.https(
      "identitytoolkit.googleapis.com",
      "/v1/accounts:update",
      {'auth': token, 'key': 'AIzaSyA1Hortv46XM9Nc8QummVhoqa3JWBycHJY'},
    ); */
/* 
    Map<String, dynamic> data = {};
 */
    /*  data = {
      'idToken': token,
      'phoneNumber': phonenumber,
      'returnSecureToken': true
    }; */

    try {
      /* final response = await http.post(
        url,
        body: json.encode(data),
      );
      final responseData = jsonDecode(response.body);

      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }

      print("update response profile ${responseData}"); */

      final params = {'auth': token}; //

      await _addInfoTOServer(name, auth.currentUser!.uid, imageFile,
          phonenumber, isAdmin, token, params);

      // Update the email in the Realtime Database if necessary
      /* final prefs = await SharedPreferences.getInstance();
      final userData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
      userData['phone'] = phonenumber;
      prefs.setString('userData', json.encode(userData)); */

      return true;
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
