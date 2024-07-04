import 'package:flutter/material.dart';
import 'package:szaman_chat/data/models/user_model.dart';
import 'package:szaman_chat/view/pages/group_inbox/group_inbox_page.dart';

class GroupListTemplet extends StatelessWidget {
  // const ChatTemplet({super.key});

  final String groupID;
  final String groupName;
  final String? lastText;
  final String lastTextDate;

  final bool isSeen;
  final bool isMe;

  final String userimageUrl;
  final Map<String, UserModel?> userModel;
  const GroupListTemplet(this.groupID, this.groupName, this.lastText,
      this.lastTextDate, this.isSeen, this.isMe,
      {super.key, required this.userimageUrl, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, //Theme.of(context).primaryColor,
      elevation: 0,
      child: ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person_3),
          ),
          title: Text(
            groupName,
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
                builder: (ctx) => GroupInboxPage(
                    groupID, groupName, userimageUrl, userModel)));

            //fID
          }),
    );

    /* Dismissible(
      key: ValueKey(groupID),
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
            leading: const CircleAvatar(
              child: Icon(Icons.person_3),
            ),
            title: Text(
              groupName,
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
                  builder: (ctx) => GroupInboxPage(
                      groupID, groupName, userimageUrl, userModel)));

              //fID
            }),
      ),
    ); */
  }
}
