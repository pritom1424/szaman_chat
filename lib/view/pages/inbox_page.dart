import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/audiocall.dart';
import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/widgets/inboxpage/inbox_messages_widget.dart';
import 'package:szaman_chat/view/widgets/inboxpage/input_inbox_widget.dart';

class InboxPage extends ConsumerWidget {
  final String fId, fName;
  final String userimageUrl;
  const InboxPage(this.fId, this.fName, this.userimageUrl, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const widthSize = 0.5;

    bool didCall = false;
    Future<void> sendCallMessages(
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
    }

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
                await sendCallMessages("Call Started!", true, false);
                await Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const CallScreen()));
                await sendCallMessages("Call Ended!", false, true);
              },
              icon: const Icon(Icons.phone))
        ],
      ),
      body: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 226, 204, 195),
        child: (Usercredential.id == null || Usercredential.token == null)
            ? const Text("no data found")
            : FutureBuilder(
                future:
                    ref.read(inboxpageViewModel).lastMessageUpdate(fId, true),
                builder: (ctx, snapLastMessage) => (snapLastMessage
                            .connectionState ==
                        ConnectionState.waiting)
                    ? SizedBox.shrink()
                    : StreamBuilder(
                        stream: ref
                            .read(inboxpageViewModel)
                            .getAllMessagesStream(
                                Usercredential.token!, Usercredential.id!, fId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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

                          didCall = (snapshot.data!.last.isCalling == true &&
                              snapshot.data!.last.isCallExit == false);
                          return (didCall)
                              ? SizedBox(
                                  height: AppVars.screenSize.height * 0.8,
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            await sendCallMessages(
                                                "Call Started!", true, false);
                                            await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        const CallScreen()));
                                            await sendCallMessages(
                                                "Call Ended!", false, true);
                                          },
                                          child: const Text("Join")),
                                      ElevatedButton(
                                          onPressed: () async {
                                            await sendCallMessages(
                                                "Call Ended!", false, true);
                                          },
                                          child: const Text("Cancel")),
                                    ],
                                  )),
                                )
                              : Column(
                                  children: [
                                    Expanded(
                                      child: InboxMessagesWidget(
                                        messages: snapshot.data!,
                                        fName: fName,
                                      ),
                                    ),
                                    InputInboxWidget(
                                      fId: fId,
                                      fName: fName,
                                      userUrl: userimageUrl,
                                    )
                                  ],
                                );
                        }),
              ),
      ),
    );
  }
}
