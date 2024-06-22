
import 'package:flutter/material.dart';
import 'package:szaman_chat/data/repositories/auth_repos.dart';

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
                AuthRepos().signInWithPhoneNumber("+16505551234");
              },
              child: const Text("Api Test")),
          ElevatedButton(
              onPressed: () async {
                String vID =
                    "AD8T5ItgLfJG9mos89zVI1NGaQiQX6G2TjI4VW0D0ZX6yU3P9aWZqAFCa9deXZrbl403H8rLLb1VxXzDCTmNsNciwQa_sqts3YER0xicFBDKk4h8S32x1QHffBSSrGAGK6bOME88z7D_l0nVglUygB2LN5gVKvdyyQ";
                //  AuthRepos().signInWithPhoneNumber("+16505551234");
              },
              child: const Text("verify")),
        ],
      ),
    );
  }
}
