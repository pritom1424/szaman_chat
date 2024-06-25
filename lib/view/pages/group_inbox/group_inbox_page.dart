import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/pages/group_inbox/group_coworkerlist_page.dart';
import 'package:szaman_chat/view/widgets/inboxpage/inbox_messages_widget.dart';
import 'package:szaman_chat/view/widgets/inboxpage/input_inbox_widget.dart';
import 'package:szaman_chat/view/widgets/inboxpage_group/group_inbox_messages_widget.dart';
import 'package:szaman_chat/view/widgets/inboxpage_group/group_input_inbox_widget.dart';

class GroupInboxPage extends ConsumerWidget {
  final String gid, gName;
  final String userimageUrl;
  const GroupInboxPage(this.gid, this.gName, this.userimageUrl, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const widthSize = 0.5;

    /*  Future<void> sendCallMessages(
        String callString, bool isCalling, bool endCalling) async {
      final resultModel = MessageModel(
          createdAt: DateTime.now(),
          message: callString,
          imageUrl: userimageUrl,
          isImageExist: false,
          isCalling: isCalling,
          isCallExit: endCalling,
          senderID: Usercredential.id!,
          /*   name: Usercredential.name,
            friendName: widget.fName, */
          isME: true);

      await ref.watch(inboxpageViewModel).addMessage(
          Usercredential.token!, resultModel, Usercredential.id!, fId);
    } */

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        // automaticallyImplyLeading: true,
        titleSpacing: 0,
        leadingWidth: 50,
        title: SizedBox(
          width: AppVars.screenSize.width * (widthSize),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FittedBox(
                  child: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: CircleAvatar(
                        child: Icon(Icons.person),
                      ) /* (ref.read(authViewModel).userId == "")
                      ? CircleAvatar(
                          backgroundImage:
                              AssetImage(ImagePath.proPicPlaceholderPath))
                      : FutureBuilder(
                          future: Provider.of<EmployeeProfileController>(
                                  context,
                                  listen: false)
                              .getEmployeeProfile(ApiLinks.employeeProfileLink,
                                  UserCredential.userid!),
                          builder: (ctx, snap) {
                            if (!snap.hasData) {
                              return CircleAvatar(
                                backgroundImage:
                                    AssetImage(ImagePath.proPicPlaceholderPath),
                              );
                            } else {
                              if (snap.data!.image == null) {
                                return CircleAvatar(
                                  backgroundImage: AssetImage(
                                      ImagePath.proPicPlaceholderPath),
                                );
                              }
                              return CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://hrms.szamantech.com/storage/employee/${snap.data!.image}"),
                              );
                            }
                          }), */
                      )),
              Text(
                "Name",
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => GroupCoworkerlistPage(
                        title: "Add member", gName, gid)));
                /*          await sendCallMessages("Call Started!", true, false);
                await Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const CallScreen()));
                await sendCallMessages("Call Ended!", false, true); */
              },
              icon: const Icon(Icons.people))
        ],
      ),
      body: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 226, 204, 195),
        child: (Usercredential.id == null || Usercredential.token == null)
            ? const Text("no data found")
            : StreamBuilder(
                stream: ref
                    .read(inboxpageGroupViewModel)
                    .getAllMessagesStream(Usercredential.token!, gid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: AppVars.screenSize.height,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: GroupInboxMessagesWidget(
                          messages: snapshot.data!,
                          gName: gName,
                        ),
                      ),
                      GroupInputInboxWidget(
                        gid: gid,
                        gName: gName,
                        userUrl: userimageUrl,
                        folderName: "groupchat_files",
                      )
                    ],
                  );
                }),
      ),
    );
  }
}
