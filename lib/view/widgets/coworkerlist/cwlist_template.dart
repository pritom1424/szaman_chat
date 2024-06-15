import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';

class CwlistTemplate extends ConsumerWidget {
  final String? imageURL, userName, uid;
  final bool isAdmin;
  final String? token;
  final String meName;
  const CwlistTemplate(
      {super.key,
      this.token,
      this.imageURL,
      required this.meName,
      this.userName,
      this.uid,
      required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            (imageURL != null) ? NetworkImage(imageURL!) : const AssetImage(""),
      ),
      title: Text(
        userName ?? "User",
        style: const TextStyle(fontWeight: FontWeight.normal),
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
                if (isAdmin) const Text("Admin"),
                /* IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ), */
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () async {
                    final mod = MessageModel(
                        createdAt: DateTime.now(),
                        message: "Welcome",
                        imageUrl: imageURL,
                        isImageExist: false,
                        isDeleted: false,
                        name: meName,
                        friendName: userName,
                        isME: true);
                    if (uid != null) {
                      final didSuccess =
                          await ref.read(userViewModel).addFriend(mod, uid!);
                      if (didSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Employee Added!")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Employee Not Added!")));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("No User Found")));
                    }
                  },
                ),
                (Usercredential.isAdmin ?? false)
                    ? IconButton(
                        onPressed: () async {
                          if (token != null && uid != null) {
                            await ref
                                .watch(authViewModel)
                                .deleteUser(token!, uid!);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("delete success")));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("not deleted")));
                          }
                        },
                        icon: const Icon(Icons.delete))
                    : const SizedBox.shrink()
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
