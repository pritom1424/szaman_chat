import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import "package:googleapis_auth/auth_io.dart" as googleauth;
import 'package:googleapis/servicecontrol/v1.dart' as sevicecontrol;
import 'package:szaman_chat/utils/constants/api_links.dart';

class FirebasePush {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static FirebasePush current = FirebasePush();

  Future<String> getAccessToken() async {
    const serviceAccoundJson = {
      "type": "service_account",
      "project_id": "szaman-chat",
      "private_key_id": "05ef7cdffe8cb532acbb6eb6ff516d0f21a07270",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC4qI8XWbVSMB4Z\nZ+jCChfQiFCf+nlK0ctt7FoAk8XcJp/umEH0pneA8S0BQ+Kt7skSuxkEeQlz2HeC\nI6+ZB/hNDqMtEnmAccG4/Pv16tGbF4Fghp2c5pJCALt9fdfI9fG51DupVL6h7ZKp\nypQ8ghHjTBGYtwppGSsfieEpqFX9XuWu7qxCSXhKAdgljS71/y+z1ZCQ9CvzxiXx\nHFaIY9L1xyqGZsVrxgrcCB1m6N+YtHjB+TAqg0pd4Fg1gl5ZUm4Dy12+WwrUc6cJ\nAxuPyMXlf1G7vhQOHRLILNwMCKx3rB2pryNeoFZxXSjAGGwsuuOplG16sX2LDAGn\nP8QVBFUBAgMBAAECgf8m82c7hbC5pWyz7zcptvdPBXH8TNlI7vf6N+DEPmd+CKez\nrGo9MOAEUtsraSZnifbf/JdKWj2kMgUDboObxBKcLno9B6iZb2Vtn++F8AJGtK6V\nrc+RSRGQ2pax4dmiij5y9FGhZj7P6U0Gg7TBDq63Q1Ry4ilQAf8Wp/7WyqtYxk7+\njbkv33i/kEGAYfElF/A6hwq+4fln1f3TK1uEConBRMyBd6JjSn5GsR9eHssoOxya\nZy4w1/e9lusn82sm/bYg07GhfIWo4Pb/DJ/U2MGT7XpQbryAvGa/+BPseBF2zQ75\nNmaphXrFVYIpM2wd3WaEpcxcMfseKaHQ8uf5ZrkCgYEA+yL9eLV5u+JxP1TW42Ro\nQ8X3NSoiANY6zvoSAkXSzZvRX6/3R2gAPWYQNU9t5V1B3/vEs4gCn3NgkaBQYwNI\n0kUTIGSEStI3Kv+HvlsBLecK7m9wTQvLkjPH9YaxQONpBsqOFYCVa2le0YT8i72T\nNn1Odp9n3Sg6gnvxnJqSFZsCgYEAvDwAwwCAwvDhK3haHmbBMYNdEv7ht/iEt2NQ\nk2HcngWK3t6nt5cW9XBZknnigmX/i1a6QO49i7O1iijG9hs068WmHryKLFpo7mg6\nys79smz9mwpbwpMK2Fm/ypW2RfhwBPpJ8gRWGQ2eM7MBaGkNhW5qY9tRfbd4m7bF\n/S0jF5MCgYB5oYe798De05xfvPpapZ2t/WpucFqJpzhSWGFygljHxkjQnEwaZG+B\nTTZaa37hUJqAHdM11JDYoyvJPCjS25tgY54Q2T4NcuTPSXV4J2FZ1wW/V2+/kQ/m\nXnfhHXwp3jpW1LGeDmnP3PfUaCFcmNN815Gx+CB4x2wXGGp7m41XMwKBgQCLUjIS\nIv4qy1Ut8o9pLw7RUfSCycpRe4znm4eY/nbnMxz9JnmmphrlIPn7M2GWuF3zSQbk\nZjGBhEra7qGMqMh7tbflyhDPET/XLahOUfRuqsLujTUrh+AgEBWnoTXfBioLVSGE\nEveS5YRxqY1iNVc/qmDudfcUAMcxIY/bexwdJwKBgQDqCTMuqm7DMMxzInL7vjWF\n90YpbDiGdbzspHkiQtG2pONguf2UaxfFk+zcbp/ZEOu8+GOTPjAsDIGJIiIghtc4\nyfaus5Gdwvza6skRMkQurFfN+WJTCy7ogbZbPz8YDlEKnSj1hNr9vv6WJ49zv+XT\n0810c/2ffBa3E+Mw4VoBNw==\n-----END PRIVATE KEY-----\n",
      "client_email": "szaman-chat@szaman-chat.iam.gserviceaccount.com",
      "client_id": "109925552752672994871",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/szaman-chat%40szaman-chat.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://accounts.google.com/auth/firebase.messaging",
      "https://accounts.google.com/auth/firebase.database",
      "https://accounts.google.com/auth/firebase.email"
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

  Future<void> sendLegacyPushNotification(String title, String body) async {
    String? deviceToken = await _messaging.getToken();
    await FirebaseMessaging.instance.requestPermission();

    const String serverKey =
        'AAAAjFtT3oo:APA91bGVW6cBiJS2BwqtTYRm9EWppxgxnTezK988iw0f5ZK2n1yLLXjnAgJRnicNJmetgb9O4rEMpBA1iOwq6TNDL0JBPQKKnbzdN9JJSzUu5D-5VbI530OYOxN-tPs2A446n6wX5Lqw';
    const String fromUrl = 'https://fcm.googleapis.com/fcm/send';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
      'Sender': 'id=602827644554',
    };

    final Map<String, dynamic> message = {
      'notification': {
        'title': title,
        'body': body,
      },
      'to': deviceToken,
    };

    final response = await http.post(
      Uri.parse(fromUrl),
      headers: headers,
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
    } else {}
  }

  Future<void> sendV1PushNotification(
      String title, String body, String uid) async {
    String? deviceToken = await _messaging.getToken();
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
      print("notification send falied");
    }
  }
}
