import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/widgets/grouplist/grouplist_widget.dart';

class GroupListPage extends StatefulWidget {
  final String? title;
  const GroupListPage({super.key, this.title});

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  final tcontroller = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    tcontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, ref, _) => Scaffold(
        appBar: (widget.title != null)
            ? AppBar(
                title: const Text("Szaman Chat"),
              )
            : null,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: const Text("Create Group"),
                      content: TextField(
                        controller: tcontroller,
                        decoration:
                            const InputDecoration(label: Text("Group Name")),
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () async {
                              if (tcontroller.text.isNotEmpty) {
                                Navigator.of(context).pop();

                                final mod = MessageModel(
                                    isCallExit: false,
                                    createdAt: DateTime.now(),
                                    message: "Welcome",
                                    imageUrl: null,
                                    isImageExist: false,
                                    isCalling: false,
                                    senderID: Usercredential.id,
                                    /* name: meName,
                          friendName: userName, */
                                    isME: true);
                                setState(() {
                                  isLoading = true;
                                });
                                await ref
                                    .watch(inboxpageGroupViewModel)
                                    .createGroup(tcontroller.text, mod);
                                setState(() {
                                  isLoading = false;

                                  tcontroller.clear();
                                });
                              }
                            },
                            child: const Text("Create"))
                      ],
                    ));
            print("dialog off");

            setState(() {});
            print("dialog on");
            /* await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (ctx) => const RegistrationForm(
                                              title: "Add Member",
                                            ))); */
          },
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Icon(
                  Icons.person_add,
                  color: Colors.black,
                ),
        ),
        body: GrouplistWidget(
          isLoaded: isLoading,
        ),
      ),
    );
  }
}
