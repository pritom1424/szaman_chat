import 'package:flutter/material.dart';
import 'package:szaman_chat/view/pages/inbox_page.dart';

class GroupListTemplet extends StatelessWidget {
  // const ChatTemplet({super.key});

  final String userId;
  final String username;
  final String lastText;
  final String lastTextDate;
  final String imageUrl;
  final bool isSeen;

  GroupListTemplet(this.userId, this.username, this.lastText, this.lastTextDate,
      this.imageUrl, this.isSeen);
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
              backgroundImage: NetworkImage(imageUrl),
            ),
            title: Text(
              username,
              style: TextStyle(
                  fontWeight: (!isSeen) ? FontWeight.bold : FontWeight.normal),
            ),
            subtitle: Text(
              lastText,
              style: TextStyle(
                  fontWeight: (!isSeen) ? FontWeight.bold : FontWeight.normal),
            ),
            trailing: Text(lastTextDate),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => InboxPage()));
            }),
      ),
    );
  }
}
