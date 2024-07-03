import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';

class CwlistTemplate extends StatefulWidget {
  final String? imageURL, userName, uid;
  final bool isAdmin;
  final String? token;
  final String meName;
  final String? fImageUrl;
  const CwlistTemplate(
      {super.key,
      this.token,
      this.imageURL,
      required this.meName,
      this.userName,
      this.uid,
      required this.isAdmin,
      required this.fImageUrl});

  @override
  State<CwlistTemplate> createState() => _CwlistTemplateState();
}

class _CwlistTemplateState extends State<CwlistTemplate> {
  late bool isAdded;
  @override
  void initState() {
    isAdded = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, ref, _) => ListTile(
        leading: CircleAvatar(
          backgroundImage: (widget.fImageUrl != null)
              ? NetworkImage(widget.fImageUrl!)
              : const AssetImage(""),
        ),
        title: Text(
          widget.userName ?? "User",
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
                  if (widget.isAdmin) const Text("Admin"),
                  /* IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  ), */
                  IconButton(
                    icon: (isAdded)
                        ? const Icon(
                            Icons.person,
                            color: Colors.blueAccent,
                          )
                        : const Icon(Icons.person_add),
                    onPressed: (isAdded)
                        ? null
                        : () async {
                            final mod = MessageModel(
                                isCallExit: false,
                                createdAt: DateTime.now(),
                                message: "Welcome",
                                imageUrl: widget.imageURL,
                                isImageExist: false,
                                isCalling: false,
                                isVideoOn: false,
                                senderID: Usercredential.id,
                                /* name: meName,
                          friendName: userName, */
                                isME: true);
                            if (widget.uid != null) {
                              isAdded = true;
                              final didSuccess = await ref
                                  .watch(userViewModel)
                                  .addFriend(mod, widget.uid!);
                              setState(() {});

                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              if (didSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Employee Added!")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Employee Not Added!")));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("No User Found")));
                            }
                          },
                  ),
                  (Usercredential.isAdmin ?? false)
                      ? IconButton(
                          onPressed: () async {
                            if (widget.token != null && widget.uid != null) {
                              await ref
                                  .watch(authViewModel)
                                  .deleteUser(widget.token!, widget.uid!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("delete success")));
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
      ),
    );
  }
}
