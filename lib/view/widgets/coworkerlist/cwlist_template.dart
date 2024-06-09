import 'package:flutter/material.dart';

class CwlistTemplate extends StatelessWidget {
  final String? imageURL, userName, uid;
  const CwlistTemplate({super.key, this.imageURL, this.userName, this.uid});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            (imageURL != null) ? NetworkImage(imageURL!) : AssetImage(""),
      ),
      title: Text(
        userName ?? "User",
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
      /*   subtitle: Text(
              lastText,
              style: TextStyle(
                  fontWeight: (!isSeen) ? FontWeight.bold : FontWeight.normal),
            ), */
      trailing: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
      onTap: () {
        /*   Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => InboxPage())); */
      },
    );
  }
}
