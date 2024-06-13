import 'package:flutter/material.dart';
import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/utils/constants/app_methods.dart';
import 'package:szaman_chat/view/widgets/inboxpage/chat_bubble.dart';

class InboxMessagesWidget extends StatelessWidget {
  final List<MessageModel> messages;
  const InboxMessagesWidget({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    /*  List<Map<String, dynamic>> data = [
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
    ]; */
    print("image: ${messages[1].imageUrl}");
    return ListView.builder(
        itemCount: messages.length,
        reverse: true,
        itemBuilder: (ctx, ind) => ChatBubble(
            date: AppMethods().dateFormatter(messages[ind].createdAt),
            isMe: messages[ind].isME,
            username: messages[ind].name ?? "User",
            message: messages[ind].message ?? "",
            userimage: messages[ind].imageUrl ?? "",
            didImageExist: messages[ind].isImageExist ?? true));
  }
}
