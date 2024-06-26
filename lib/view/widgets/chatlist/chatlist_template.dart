import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/pages/inbox_page.dart';

class ChatListTemplet extends StatelessWidget {
  // const ChatTemplet({super.key});

  final String userId;
  final String username;
  final String? lastText;
  final String lastTextDate;
  final String fimageUrl;
  final bool isSeen;
  final bool isMe;
  final String friendName;
  final String imageUrl;
  final WidgetRef ref;
  const ChatListTemplet(
      this.userId,
      this.username,
      this.lastText,
      this.lastTextDate,
      this.fimageUrl,
      this.isSeen,
      this.isMe,
      this.friendName,
      {super.key,
      required this.imageUrl,
      required this.ref});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(userId),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).primaryColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      onDismissed: (direction) {
        //  FriendList.current.DeleteContact(userId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Are You Sure?"),
                  content: const Text("Do you want to delete this contact?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                ));
      },
      child: Card(
        color: Colors.white, //Theme.of(context).primaryColor,
        elevation: 0,
        child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(fimageUrl),
            ),
            title: Text(
              friendName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: (!isSeen) ? FontWeight.bold : FontWeight.normal),
            ),
            subtitle: Text(
              lastText ?? "sent a photo",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: (!isSeen) ? FontWeight.bold : FontWeight.normal),
            ),
            trailing: Text(lastTextDate),
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => InboxPage(userId, friendName, imageUrl)));

              //fID
            }),
      ),
    );
  }
}
