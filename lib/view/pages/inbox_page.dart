import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/audiocall.dart';
import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/utils/audio/sound_manager.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/constants/app_methods.dart';
import 'package:szaman_chat/utils/constants/app_paths.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/widgets/inboxpage/inbox_messages_widget.dart';
import 'package:szaman_chat/view/widgets/inboxpage/input_inbox_widget.dart';

class InboxPage extends ConsumerWidget {
  final String fId, fName;
  final String userimageUrl;
  final String fImageUrl;
  final String userName;
  const InboxPage(
      this.fId, this.fName, this.userimageUrl, this.fImageUrl, this.userName,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const widthSize = 0.8;

    bool didCall = false;
    bool didVideoOn = false;

    Future<void> sendCallMessages(String callString, bool isCalling,
        bool endCalling, bool isVidOn) async {
      final resultModel = MessageModel(
          createdAt: DateTime.now(),
          message: callString,
          imageUrl: userimageUrl,
          isImageExist: false,
          isCalling: isCalling,
          isCallExit: endCalling,
          isVideoOn: isVidOn,
          senderID: Usercredential.id!,
          /*   name: Usercredential.name,
            friendName: widget.fName, */
          isME: true);
      final callStatus = await ref.watch(inboxpageViewModel).getCallStatus();
      if ((callStatus == 1 || callStatus == 2) &&
          (isCalling == true && endCalling == false)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$fName is busy!")));
      } else {
        await ref.watch(inboxpageViewModel).addMessage(Usercredential.token!,
            resultModel, Usercredential.id!, fId, userName);
      }
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        // automaticallyImplyLeading: true,
        titleSpacing: 0,
        leadingWidth: 50,
        title: SizedBox(
          width: AppVars.screenSize.width * (widthSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const FittedBox(
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
                fName,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: AppVars.screenSize.width * (0.3),
                child: StreamBuilder(
                    stream: ref.read(userViewModel).getStatusStream(fId),
                    builder: (context, snapState) {
                      bool status = false;
                      if (snapState.hasData) {
                        if (snapState.data!.isNotEmpty) {
                          status = snapState.data![0];
                        }
                        print("has data");
                      }
                      print("has data");
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 6,
                            backgroundColor: (status)
                                ? Colors.yellow
                                : const Color.fromARGB(255, 71, 70, 70),
                          ),
                          if (snapState.hasData && snapState.data!.isNotEmpty)
                            SizedBox(
                              width: 5,
                            ),
                          if (snapState.hasData && snapState.data!.isNotEmpty)
                            Text(
                              (status)
                                  ? "active now"
                                  : AppMethods().formatTimeAgoOrDate(
                                      snapState.data![1],
                                    ),
                              style: TextStyle(fontSize: 15),
                            )
                        ],
                      );
                    }),
              )
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                if (Usercredential.id == null) {
                  return;
                }

                await sendCallMessages("Call Started!", true, false, true);
                didVideoOn = true;
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => CallScreen(
                          fid: fId,
                          channelName: Usercredential.id!,
                          imageURL: fImageUrl,
                          isVideoOn: didVideoOn,
                        )));
                await sendCallMessages("Call Ended!", false, true, false);
                didVideoOn = false;
              },
              icon: const Icon(Icons.video_camera_front)),
          IconButton(
              onPressed: () async {
                if (Usercredential.id == null) {
                  return;
                }

                await sendCallMessages("Call Started!", true, false, false);
                didVideoOn = false;
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => CallScreen(
                          fid: fId,
                          channelName: Usercredential.id!,
                          imageURL: fImageUrl,
                          isVideoOn: didVideoOn,
                        )));

                await sendCallMessages("Call Ended!", false, true, false);
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
                    ? const SizedBox.shrink()
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
                              snapshot.data!.last.isCallExit == false &&
                              snapshot.data!.last.isME == false &&
                              !SoundManager.isPush);
                          if (didCall) {
                            SoundManager()
                                .playSound(AppPaths.callStartSoundPath);
                          } else {
                            SoundManager().stopSound();
                          }

                          return (didCall)
                              ? SizedBox(
                                  height: AppVars.screenSize.height * 0.8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                        radius: 20,
                                        child: Icon(
                                          Icons.call,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text("Ringing..."),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 52, 128, 54),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              onPressed: () async {
                                                SoundManager.isPush = true;
                                                /*  await sendCallMessages(
                                                    "Call Started!",
                                                    true,
                                                    false,
                                                    didVideoOn); */
                                                await Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            CallScreen(
                                                              isVideoOn: snapshot
                                                                      .data!
                                                                      .last
                                                                      .isVideoOn ??
                                                                  false,
                                                              fid: fId,
                                                              channelName: fId,
                                                              imageURL:
                                                                  fImageUrl,
                                                            )));
                                                didVideoOn = false;
                                                await SoundManager()
                                                    .stopSound();
                                                if (snapshot.data!.last
                                                            .isCalling ==
                                                        true &&
                                                    snapshot.data!.last
                                                            .isCallExit ==
                                                        false) {
                                                  await sendCallMessages(
                                                      "Call Ended!",
                                                      false,
                                                      true,
                                                      didVideoOn);
                                                  SoundManager.isPush = false;
                                                }
                                              },
                                              child: const Text("Receive")),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              onPressed: () async {
                                                SoundManager.isPush = false;
                                                await SoundManager()
                                                    .stopSound();
                                                await sendCallMessages(
                                                    "Call Ended!",
                                                    false,
                                                    true,
                                                    false);
                                                SoundManager.isPush = false;
                                              },
                                              child: const Text("Cancel")),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    Expanded(
                                      child: InboxMessagesWidget(
                                        messages: snapshot.data!,
                                        fName: fName,
                                      ),
                                    ),
                                    ref.read(inboxpageViewModel).isDocUploading
                                        ? Container(
                                            height: AppVars.screenSize.height *
                                                0.05,
                                            width:
                                                AppVars.screenSize.width * 0.1,
                                            padding: const EdgeInsets.all(5),
                                            child:
                                                const CircularProgressIndicator(
                                              color: Colors.blueAccent,
                                              strokeWidth: 8,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    InputInboxWidget(
                                      fId: fId,
                                      fName: fName,
                                      userUrl: userimageUrl,
                                      userName: userName,
                                    )
                                  ],
                                );
                        }),
              ),
      ),
    );
  }
}
