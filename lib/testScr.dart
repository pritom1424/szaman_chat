import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:szaman_chat/utils/constants/app_paths.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';

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
            //  final ref = FirebaseStorage.instance.ref();
            /*      final ref = FirebaseStorage.instanceFor(
                    bucket: "gs://szaman-chat.appspot.com")
                .ref()
                .child("test"); */
            var params = {
              "auth":
                  "eyJhbGciOiJSUzI1NiIsImtpZCI6IjMzMDUxMThiZTBmNTZkYzA4NGE0NmExN2RiNzU1NjVkNzY4YmE2ZmUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vc3phbWFuLWNoYXQiLCJhdWQiOiJzemFtYW4tY2hhdCIsImF1dGhfdGltZSI6MTcxODA4OTg5MywidXNlcl9pZCI6IkNQT2U1S3IyMWxOSVVDSjNwZkROa3A4VmMzTzIiLCJzdWIiOiJDUE9lNUtyMjFsTklVQ0ozcGZETmtwOFZjM08yIiwiaWF0IjoxNzE4MDg5ODkzLCJleHAiOjE3MTgwOTM0OTMsImVtYWlsIjoic3phbWFudGVjaDI0QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJzemFtYW50ZWNoMjRAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.RAVSHLJuuFxcY_1-Mqi-DilC2_D_CKqiFjiodHkHYt2BDt-CQv4TkJAUOZklyl4ZaV6ZVH75bxf9ZBZYHxogCkkiEK5KJdTy42WntoiKRA4pL6rvlDdS7VtgUcETASIbUHk2yTQBDD3z-BbuzXhPpgRehBjPL6aNO9uucJe8KQUir7zyBkX6UOVU65Og1QxEazLuaY-Ji_WiGKrQr5gc1wad35pkM87_gRcwvGE3wDazLCas7PqIETXixy5DoBBHJ2sS8sZPkiuciHA8eebdwb1JRUsibjve4YG4zB2vJ0qA2UB6N7mKWsRWDO_3TEq7wPpdyt_wvRWxmTmVVPyzQA"
            };
            final url = Uri.https('szaman-chat-default-rtdb.firebaseio.com',
                '/users.json', params);

            final ref = await http.get(url);

            if (ref.statusCode == 200) {
              final data = json.decode(ref.body) as Map<String, dynamic>;

              final strings = data.values.map((data) => data['name']).toList();

              print("res ${data}");
            } else {
              print("not authorized");
            }

            /*    .child('profile_images')
                .child("test"); */

            /*  final url = Uri.https(
                'szaman-chat-default-rtdb.firebaseio.com', '/products.json');
            final response = await http.post(url,
                body: json.encode({
                  "title": "test",
                  "description": "test is a ...",
                  "imageUrl": "url",
                  "price": 100,
                  "creatorId": DateTime.now().toIso8601String(),
                })); */
          },
          child: Text("Api Test")),
    );
  }
}
