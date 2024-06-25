import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:szaman_chat/main.dart';
import 'package:szaman_chat/utils/constants/api_links.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';

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
                // AuthRepos().signInWithPhoneNumber("+16505551234");
                final token = await auth.currentUser!.getIdToken();
                var params = {'auth': token};
                print("params" + params.toString());
                final url = Uri.https(ApiLinks.baseUrl, '/test.json', params);
                final response = await http.post(url,
                    body: jsonEncode({"admin": auth.currentUser!.uid}));

                print("Checking test:" + json.decode(response.body).toString());
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
