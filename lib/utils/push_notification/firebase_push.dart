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

class FirebasePush {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static FirebasePush current = FirebasePush();

  Future<String> getAccessToken() async {
    final serviceAccoundJson = {
      "type": "service_account",
      "project_id": "szaman-chat",
      "private_key_id": "bfc0e4803345fa429b412b4cb5b42f055d42525e",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDEZ4OcrLlBXnZe\ntBQyMzH+TsKMZtCXT4ySB66rTDawDuZ0mokyetvr05JeulB47MZnX2rhT8wZG+4X\n5c1Ghas0vVLyD4y51IcTpC1Q/5dYVZhdBcoCTRNC0Wb23iN7VWlohn5iWt0dyh3B\n8dhcfoiM3TiMl0yEvI8yK0k2CQboCY9aOOVEkJevHCK5s32XIiirlox1xLfdcdOE\nwMLmJUt+QktmaHltATK+PXEoON7P+tO4gU4ib3kLC9WZ6B8+uqgLsP1SSAaaI+Wx\nLNLlJkA8qaJ081tQ/2Ki59i11VstDMOwXM6zaLHtKFcRCA54VRFFKvMMlT2ofIOL\neCBgoI57AgMBAAECggEAI9VTAOHOhuuqIwst6B7JD0HlYuJbSk/8MKRwLNah36tI\nRpvvTiN2PmeCe//4MKfaZv/Uqzj43tfmr7uAoU4/90ZXfMxze3AYGPBKSE3pmfc7\n7jThL1xKmFVGOOI8jQL/UU/AfUdgsk+u8DSkqfN4DGNMLvJnxov0gE2/dLle5jSO\nZmoOnvkYu6sUKdN07SHyq1ZZJKsZbaXWBMgHsIOHabwzcvVj3cDKhky7/fNmQBHf\nWDYilMFsYV1m4AavPV9nvcgFkxSNpquOv6nJW2/coOdLPlKJMD6Vs0MUk3fuAXEA\nJslq2SGXqrwa6mU3m6i1AlVelGcLsyr8cl1e1y9FMQKBgQDrDZ38FWterdSW6hfH\nWzQ5hCEUqGyNYtiIesUCU56QGg9tua/nvKwI5MCJdvPgvfLpBqfNR2XhgNvY0NiD\nCwEdV21KJQZQJuutEGC0lpjTbpJ7DpQqqfV4VmPF/Wcj0aR/IxtCXnp7NqfXi1iE\nnrh5Eqp+9Rq/G2PM+5UFEnMykwKBgQDV6C6jtTigYLVGuQdd7SofQaSaRZ7yDCOA\njQiGIfgOldBlqv195yDaTyxlohTWQlRSBJFbHK47eymJsnuYxnSZWDpLFDRF3wlC\njsI0gRjNlWB67cCYSCd704hLXBQBas0NuaX4GSTrtNu2Yq1rNwRa0FQdeLWl62+a\ndu1LH6EdeQKBgC2bWsgKr+aS++i8SxjXTW7LgE+tzkIwp6rzhz5IUz/KjqvPl53z\nMb4YBHOnrPIyaOtl6zEdZVs30XBkNV5XyEOVLxNv06XBp4DQ6LKhdc2waqON1Jni\nmEpdGMbVwClnB+/TM/rQshsuI6ri0q4IzepQANzZWfMysU6YkfWF+uwZAoGAfCjA\nqZVOwQhhMCPF+ubmRC499K3kjGovUTaLdA/Tg+PBisGtUZ8OmqjKBFQH9DWb699q\n34/OMghTG/HVe9/1XeywKVQY41WKcm+amg807l9+GNxXpgx7nowx2Ewh8JClZQoV\nI+S0YXwg68RrFIhiprO1n0Wpah02MlpFcg1x30ECgYEAop6OHh8xgAFp9oRs2qlz\nLn9dLenNnv6LwTQWFruVH/G9roVS56MnoPIUZIcG5E8gdMzcmsixSIpbDjhWnTdn\n9dqpmxcZdJn00ptvuWIg/VcfAW+UyEgp0EMwHWI3udTIJlZBwZmgdawgUNIfB1nC\nh4WTuPYb8KS+S0fChGp/0/Y=\n-----END PRIVATE KEY-----\n",
      "client_email": "szaman-chat@szaman-chat.iam.gserviceaccount.com",
      "client_id": "114508874980249239715",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/szaman-chat%40szaman-chat.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await googleauth.clientViaServiceAccount(
        googleauth.ServiceAccountCredentials.fromJson(serviceAccoundJson),
        scopes);
    print("pass service account");
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
