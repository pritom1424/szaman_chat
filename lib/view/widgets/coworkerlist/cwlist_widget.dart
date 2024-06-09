import 'package:flutter/material.dart';
import 'package:szaman_chat/view/widgets/coworkerlist/cwlist_template.dart';

class CwlistWidget extends StatelessWidget {
  const CwlistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {
        "uId": "0",
        "username": "user0",
        "imageUrl":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
      },
      {
        "uId": "2",
        "username": "user2",
        "imageUrl":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
      },
      {
        "uId": "3",
        "username": "user3",
        "imageUrl":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
      },
      {
        "uId": "4",
        "username": "user4",
        "imageUrl":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
      },
    ];
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (ctx, ind) => CwlistTemplate(
              uid: data[ind]["uId"],
              imageURL: data[ind]["imageUrl"],
              userName: data[ind]["username"],
            ));
  }
}
