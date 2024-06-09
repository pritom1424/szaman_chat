import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestScript extends StatelessWidget {
  const TestScript({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: ElevatedButton(
          onPressed: () async {
            final url = Uri.https(
                'szaman-chat-default-rtdb.firebaseio.com', '/products.json');
            final response = await http.post(url,
                body: json.encode({
                  "title": "test",
                  "description": "test is a ...",
                  "imageUrl": "url",
                  "price": 100,
                  "creatorId": DateTime.now().toIso8601String(),
                }));
          },
          child: Text("Api Test")),
    );
  }
}
