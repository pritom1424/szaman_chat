import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:szaman_chat/main.dart';
import 'package:szaman_chat/utils/constants/api_links.dart';
import 'package:szaman_chat/utils/constants/app_paths.dart';
import 'package:szaman_chat/utils/push_notification/firebase_push.dart';

class AuthRepos {
  final _params = {
    'key': 'AIzaSyA1Hortv46XM9Nc8QummVhoqa3JWBycHJY',

    // Replace with your actual API key
  };

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

        final params = {"auth": token};
        final deviceToken = await FirebasePush().getDeviceToken();
        await _addInfoTOServer(
            auth.currentUser?.displayName,
            userInfo.user!.uid,
            imageFile,
            phoneNumber,
            isAdmin,
            deviceToken ?? "",
            params);
        _storeUserData();

        return userInfo;
      }
    } catch (e) {
      print('Error in verifying OTP: $e');
      return null;
    }
    return null;
  }

  Future<bool> updateDeviceToken(String uid, String token) async {
    final deviceToken = await FirebasePush().getDeviceToken();
    var params = {'auth': token};

    final url = Uri.https(ApiLinks.baseUrl, '/users/$uid.json', params);

    final body = {"token": deviceToken ?? "default"};
    final response = await http.patch(url, body: jsonEncode(body));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
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

  Future<void> _addInfoTOServer(
      String? username,
      String userId,
      File? imageFile,
      String phoneNumber,
      bool isAdmin,
      String token,
      Map<String, dynamic> params) async {
    if (username != null) {
      final link = Uri.https(ApiLinks.baseUrl, '/users/$userId.json', params);

      final ref = FirebaseStorage.instanceFor(bucket: ApiLinks.baseCloudURl)
              .ref()
              .child('profile_images')
              .child(userId) //responseData['localId']
          ;
      String? durl;
      try {
        durl = await ref.getDownloadURL();
      } catch (e) {
        durl = null;
      }
      // await ref.putFile(imageFile);
      if (durl == null) {
        if (imageFile != null) {
          await ref.putFile(imageFile);
        } else {
          final ByteData byteData =
              await rootBundle.load(AppPaths.charplaceholderPath);
          final Uint8List imageData = byteData.buffer.asUint8List();

          await ref.putData(imageData);
        }
        durl = await ref.getDownloadURL();
      }

      final response = await http.put(link,
          body: json.encode({
            "creatorId": DateTime.now().toIso8601String(),
            "phone": phoneNumber,
            "imageUrl": durl,
            "isAdmin": isAdmin,
            "name": username,
            "token": token
          }));
    }
  }

  Future<void> _updateInfoTOServer(String? username, String userId,
      File? imageFile, bool isAdmin, Map<String, dynamic> params) async {
    if (username != null) {
      final link = Uri.https(ApiLinks.baseUrl, '/users/$userId.json', params);

      final ref = FirebaseStorage.instanceFor(bucket: ApiLinks.baseCloudURl)
              .ref()
              .child('profile_images')
              .child(userId) //responseData['localId']
          ;
      // await ref.putFile(imageFile);

      String? durl = await ref.getDownloadURL();

      if (imageFile != null) {
        await ref.putFile(imageFile);
        durl = await ref.getDownloadURL();
      } else {
        if (durl.isEmpty) {
          final ByteData byteData =
              await rootBundle.load(AppPaths.charplaceholderPath);
          final Uint8List imageData = byteData.buffer.asUint8List();

          await ref.putData(imageData);
          durl = await ref.getDownloadURL();
        }
      }

      final response = await http.patch(link,
          body: json.encode({
            "imageUrl": durl,
            "isAdmin": isAdmin,
            "name": username,
          }));
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
    _storeUserData();
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("userData")) {
      return null;
    }

    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

    return extractedData;
  }

  Future<bool?> updateAccount(String token, String name, String uid,
      File? imageFile, bool isAdmin) async {
    try {
      final params = {'auth': token}; //

      await _updateInfoTOServer(name, uid, imageFile, isAdmin, params);

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
