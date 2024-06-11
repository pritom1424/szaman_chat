import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';

class CwlistTemplate extends ConsumerWidget {
  final String? imageURL, userName, uid;
  final bool isAdmin;
  final String? token;
  const CwlistTemplate(
      {super.key,
      this.token,
      this.imageURL,
      this.userName,
      this.uid,
      required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      trailing: IconButton(
          onPressed: () {},
          icon: FittedBox(
            child: Row(
              children: [
                if (isAdmin) Text("Admin"),
                /* IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ), */
                IconButton(
                  icon: Icon(Icons.person_add),
                  onPressed: () {},
                ),
                (Usercredential.isAdmin ?? false)
                    ? IconButton(
                        onPressed: () async {
                          if (token != null && uid != null) {
                            await ref
                                .watch(authViewModel)
                                .deleteUser(token!, uid!);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("delete success")));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("not deleted")));
                          }
                        },
                        icon: Icon(Icons.delete))
                    : SizedBox.shrink()
              ],
            ),
          )),
      onTap: () {
        /*   Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => InboxPage())); */
      },
    );
  }
}
