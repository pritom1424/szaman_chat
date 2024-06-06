import 'package:flutter/material.dart';
import 'package:szaman_chat/view/widgets/chatlist/chatlist_template.dart';

class GrouplistWidget extends StatelessWidget {
  const GrouplistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {
        "uId": "0",
        "lastTextDate": "6-6-2024",
        "username": "group0",
        "lastText": "user1",
        "imageUrl":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
        "isSeen": true,
      },
      {
        "uId": "2",
        "lastTextDate": "6-6-2024",
        "username": "group1",
        "lastText": "user1",
        "imageUrl":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
        "isSeen": false,
      },
      {
        "uId": "3",
        "lastTextDate": "6-6-2024",
        "username": "group2",
        "lastText": "user1",
        "imageUrl":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
        "isSeen": true,
      },
      {
        "uId": "4",
        "lastTextDate": "6-6-2024",
        "username": "group3",
        "lastText": "user1",
        "imageUrl":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
        "isSeen": true,
      },
    ];
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (ctx, ind) => ChatListTemplet(
            data[ind]["uId"],
            data[ind]["username"],
            data[ind]["lastText"],
            data[ind]["lastTextDate"],
            data[ind]["imageUrl"],
            data[ind]["isSeen"]));
  }
}
