import 'package:flutter/material.dart';
import 'package:szaman_chat/view/widgets/inboxpage/chat_bubble.dart';

class InboxMessagesWidget extends StatelessWidget {
  const InboxMessagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {
        "date": "6-6-2024",
        "isMe": false,
        "username": "user1",
        "userimage":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
        "didExist": false,
        "message":
            "hi there! how are you im jack and you and what is your purpose 0"
      },
      {
        "date": "6-6-2024",
        "isMe": true,
        "username": "user1",
        "userimage":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
        "didExist": false,
        "message":
            "hi there! how are you im jack and you and what is your purpose 1"
      },
      {
        "date": "6-6-2024",
        "isMe": false,
        "username": "user1",
        "userimage":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
        "didExist": false,
        "message":
            "hi there! how are you im jack and you and what is your purpose 2"
      },
      {
        "date": "6-6-2024",
        "isMe": true,
        "username": "user1",
        "userimage":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
        "didExist": false,
        "message":
            "hi there! how are you im jack and you and what is your purpose 3"
      }
    ];
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (ctx, ind) => ChatBubble(
            date: data[ind]['date'],
            isMe: data[ind]['isMe'],
            username: data[ind]['username'],
            message: data[ind]['message'],
            userimage: data[ind]['userimage'],
            didImageExist: data[ind]['didExist']));
  }
}
