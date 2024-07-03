import 'package:flutter/material.dart';
import 'package:szaman_chat/utils/push_notification/firebase_push.dart';

class TestScript extends StatelessWidget {
  const TestScript({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                FirebasePush().showNotification(context);

                /*         await FirebasePush().sendV1PushNotification(
                    "hello", "hi there!", Usercredential.id!); */

                // AuthRepos().signInWithPhoneNumber("+16505551234");
                /*  final token = await auth.currentUser!.getIdToken();
                var params = {'auth': token}; */
                /*      print("params$params");
                final url = Uri.https(ApiLinks.baseUrl, '/test.json', params);
                final response = await http.post(url,
                    body: jsonEncode({"admin": auth.currentUser!.uid}));
                      print("Checking test:${json.decode(response.body)}");
                    
                     */
                /*  final Locale? deviceLocale = CountryCodes.getDeviceLocale();
                print("deviceLocale $deviceLocale");
                print(
                    "auth mobile: ${CountryCodes.detailsForLocale().dialCode.toString()}"); */
                /* final ref =
                    FirebaseStorage.instanceFor(bucket: ApiLinks.baseCloudURl)
                        .ref()
                        .child('profile_images')
                        .child("1234");

                String? durl;
                try {
                  durl = await ref.getDownloadURL();
                } catch (e) {
                  durl = null;
                }
                print("Checking test:${durl}"); */
              },
              child: const Text("Api Test")),
          ElevatedButton(
              onPressed: () async {
                // String vID =
                //     "AD8T5ItgLfJG9mos89zVI1NGaQiQX6G2TjI4VW0D0ZX6yU3P9aWZqAFCa9deXZrbl403H8rLLb1VxXzDCTmNsNciwQa_sqts3YER0xicFBDKk4h8S32x1QHffBSSrGAGK6bOME88z7D_l0nVglUygB2LN5gVKvdyyQ";
                //  AuthRepos().signInWithPhoneNumber("+16505551234");
              },
              child: const Text("verify")),
        ],
      ),
    );
  }
}
