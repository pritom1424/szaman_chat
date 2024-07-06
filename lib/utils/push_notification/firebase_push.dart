import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:http/http.dart' as http;
import "package:googleapis_auth/auth_io.dart" as googleauth;
import 'package:permission_handler/permission_handler.dart';
import 'package:szaman_chat/utils/constants/api_links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:szaman_chat/utils/constants/app_constant.dart';

class FirebasePush {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static FirebasePush current = FirebasePush();

  Future<String> getAccessToken() async {
    const serviceAccoundJson = AppConstant.pushServiceAccountJson;

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await googleauth.clientViaServiceAccount(
        googleauth.ServiceAccountCredentials.fromJson(serviceAccoundJson),
        scopes);

    googleauth.AccessCredentials credentials =
        await googleauth.obtainAccessCredentialsViaServiceAccount(
            googleauth.ServiceAccountCredentials.fromJson(serviceAccoundJson),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }

  Future<String?> getDeviceToken() async {
    String? token = await _messaging.getToken();

    return token;
  }

  Future<void> sendV1PushNotification(
      String title, String body, String uid, String deviceToken) async {
    try {
      await FirebaseMessaging.instance.requestPermission();

      final String serverKey = await getAccessToken();

      String endPointFCM = ApiLinks.endPointFCM;

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
        //'Sender': 'id=602827644554',
      };

      final Map<String, dynamic> message = {
        "message": {
          "token": deviceToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {'uid': uid}
        }
      };

      final response = await http.post(
        Uri.parse(endPointFCM),
        headers: headers,
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print("notification send success");
      } else {
        print(
            "notification send falied ${response.statusCode}${json.decode(response.body)}");
      }
    } catch (e) {
      print("push error $e");
    }
  }

  /* Future<void> _showIncomingCallNotification(RemoteMessage message) async {
    print("show incoming call notification begin before");
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'incoming_call_channel', // id
      'Incoming Calls', // name
      channelDescription: 'Channel for incoming calls', // description
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      fullScreenIntent: true,
    );
    print("show incoming call notification begin");
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    print("show incoming call notification before");
    await FlutterLocalNotificationsPlugin().show(
      0, // notification id
      message.data['caller_name'],
      'is calling you...',
      platformChannelSpecifics,
    );
    print("show incoming call notification after");

    // Optionally, repeat the notification
    // Repeat logic here (e.g., using a timer or scheduling multiple notifications)
  } */

  /* Future<void> repeatIncomingCallNotification(RemoteMessage message) async {
    print("show incoming call notification begin before rep");
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAcHQuKlLrw59V6hD96CxEzqhjSj94LmJA",
            appId: "1:434564582098:android:fdec4b070aca961bbd3b0b",
            messagingSenderId: "434564582098",
            projectId: "szaman-chat"));
    Timer.periodic(Duration(seconds: 10), (timer) async {
      // Show the notification again
      print("show incoming call notification begin before rep");
      await _showIncomingCallNotification(message);
    });
  } */

  Future<bool> showNotification(BuildContext context) async {
    final notifyStat = await Permission.notification.status;

    final prfs = await SharedPreferences.getInstance();
    bool didAsk = prfs.getBool('didAsk') ?? false;

    if (!notifyStat.isGranted) {
      if (!didAsk) {
        Future.delayed(const Duration(seconds: 2), () async {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text("Permission Alert!"),
                    content: RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "\n\nNotification Permission!\n\n",
                          style: Theme.of(context).textTheme.bodyLarge),
                      TextSpan(
                          text:
                              "If you do not allow this permission, you will not be able to get message alerts!",
                          style: Theme.of(context).textTheme.bodyMedium)
                    ])),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close")),
                      ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await openAppSettings();
                          },
                          child: const Text("Open Settings"))
                    ],
                  ));
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('didAsk', true);
          return true;
        });
      }
    }
    return false;
  }
}
