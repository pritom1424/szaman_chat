import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';

class GroupCwlistTemplate extends StatefulWidget {
  final String? imageURL, userName, userID;
  final String? mainGroupName;
  final bool isAdmin;
  final String? token;
  final String meName;
  final String? gId;
  const GroupCwlistTemplate(
      {super.key,
      this.token,
      this.imageURL,
      required this.meName,
      this.userName,
      this.userID,
      required this.isAdmin,
      this.mainGroupName,
      this.gId});

  @override
  State<GroupCwlistTemplate> createState() => _CwlistTemplateState();
}

class _CwlistTemplateState extends State<GroupCwlistTemplate> {
  late bool isAdded;
  @override
  void initState() {
    isAdded = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("added $isAdded");
    return Consumer(
      builder: (ctx, ref, _) => ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person_3),
        ),
        title: Text(
          widget.userName ?? "Group",
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
                            if (widget.userID != null) {
                              isAdded = true;
                              print(
                                  "before added memb  ${widget.mainGroupName!}");
                              final didSuccess = await ref
                                  .watch(inboxpageGroupViewModel)
                                  .addMember(widget.gId!, widget.mainGroupName!,
                                      widget.userID!);
                              print("after added memb");

                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              if (didSuccess) {
                                print("added memb");
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Member Added!")));
                              } else {
                                print("not added memb");
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Member Not Added!")));
                              }
                            } else {
                              print("no user memb");
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("No User Found")));
                            }
                          },
                  ),
                  (Usercredential.isAdmin ?? false)
                      ? IconButton(
                          onPressed: () async {
                            if (widget.token != null && widget.userID != null) {
                              await ref
                                  .watch(authViewModel)
                                  .deleteUser(widget.token!, widget.userID!);
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
