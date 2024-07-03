import 'package:flutter/material.dart';
import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/data/models/user_model.dart';
import 'package:szaman_chat/utils/constants/app_methods.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/view/widgets/inboxpage_group/group_chat_bubble.dart';

class GroupInboxMessagesWidget extends StatelessWidget {
  final List<MessageModel> messages;
  final String? gName;
  final Map<String, UserModel?> userData;
  const GroupInboxMessagesWidget(
      {super.key, required this.messages, this.gName, required this.userData});

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

    final messageList = messages.reversed.toList();
    return ListView.builder(
        itemCount: messageList.length,
        reverse: true,
        itemBuilder: (ctx, ind) => GroupChatBubble(
              date: AppMethods().dateFormatter(messageList[ind].createdAt),
              isMe: messageList[ind].isME,
              username: (messageList[ind].senderID == Usercredential.id)
                  ? "You"
                  : userData[messageList[ind].senderID]!.name ?? "name",
              message: messageList[ind].message ?? "",
              userimage: messageList[ind].imageUrl ?? "",
              didImageExist: messageList[ind].isImageExist ?? false,
              senderID: messageList[ind].senderID ?? "",
            ));
  }
}
