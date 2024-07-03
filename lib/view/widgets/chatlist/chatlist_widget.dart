import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/utils/audio/sound_manager.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/constants/app_methods.dart';
import 'package:szaman_chat/utils/constants/app_paths.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/widgets/chatlist/chatlist_template.dart';

class ChatlistWidget extends ConsumerWidget {
  const ChatlistWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool didCall = false;
    bool didCallEnd = false;
    int currentInd = -1;
    return (Usercredential.id != null || Usercredential.token != null)
        ? FutureBuilder(
            future: ref
                .read(profileViewModel)
                .getInfo(Usercredential.token!, Usercredential.id!),
            builder: (ctx, snapUserProf) => (snapUserProf.connectionState ==
                    ConnectionState.waiting)
                ? SizedBox(
                    height: AppVars.screenSize.height,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : FutureBuilder(
                    future: ref
                        .read(inboxpageViewModel)
                        .getFriendIDs(Usercredential.id!),
                    /*  stream: ref
                        .read(inboxpageViewModel)
                        .getFriendIDsStream(Usercredential.id!), */
                    builder: (ctx, snapId) {
                      if (snapId.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: AppVars.screenSize.height,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (!snapId.hasData) {
                        return const Center(
                          child: Text(
                            "No contacts added till now!\n Add some!",
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return ListView.builder(
                          itemCount: snapId.data!.length,
                          itemBuilder: (ctx, ind) => FutureBuilder(
                              future: ref.read(profileViewModel).getInfo(
                                  Usercredential.token!, snapId.data![ind]),
                              builder: (context, snapPhoto) {
                                if (snapPhoto.connectionState ==
                                        ConnectionState.waiting &&
                                    ind == 0) {
                                  return SizedBox(
                                    height: AppVars.screenSize.height * 0.8,
                                    child: const Center(
                                      child: Text("Loading..."),
                                    ),
                                  );
                                }
                                if (!snapPhoto.hasData) {
                                  return const SizedBox.shrink();
                                }

                                return FutureBuilder(
                                    future: ref
                                        .read(userViewModel)
                                        .getInfo(Usercredential.token!),
                                    builder: (ctx, snapUsers) {
                                      if (!snapUsers.hasData) {
                                        return const SizedBox.shrink();
                                      }

                                      return StreamBuilder(
                                          stream: ref
                                              .read(inboxpageViewModel)
                                              .isLastMessageSeenStream(
                                                  snapId.data![ind]),
                                          builder: (ctx, snapIsSeen) {
                                            if (!snapIsSeen.hasData) {
                                              return const SizedBox.shrink();
                                            } else if (snapIsSeen
                                                .data!.isEmpty) {
                                              return const SizedBox.shrink();
                                            }

                                            final mModel =
                                                snapIsSeen.data!['message']
                                                    as MessageModel;

                                            return FutureBuilder(
                                                future: ref
                                                    .read(inboxpageViewModel)
                                                    .getCallStatus(),
                                                builder: (context, snapCall) {
                                                  if (!snapCall.hasData) {
                                                    const SizedBox.shrink();
                                                  }

                                                  if (snapCall.data == 1 &&
                                                      !SoundManager.isPush) {
                                                    SoundManager().playSound(
                                                        AppPaths
                                                            .callStartSoundPath);
                                                  } else {
                                                    SoundManager().stopSound();
                                                  }
                                                  return ChatListTemplet(
                                                    imageUrl: snapUserProf
                                                        .data!.imageUrl!,
                                                    snapId.data![ind],
                                                    snapUsers
                                                            .data![
                                                                Usercredential
                                                                    .id]
                                                            ?.name ??
                                                        "user",
                                                    /*     /* snap.data![0].name ??  */ "user", */
                                                    mModel.message ?? "message",
                                                    AppMethods().dateFormatter(
                                                        mModel.createdAt),
                                                    snapPhoto.data!.imageUrl!,
                                                    snapIsSeen.data![
                                                            "communicate"] ??
                                                        true,
                                                    mModel.isME,
                                                    snapUsers
                                                            .data![snapId
                                                                .data![ind]]
                                                            ?.name ??
                                                        "friends",
                                                    ref: ref,
                                                    // data[ind]["isSeen"]
                                                  );
                                                });
                                          });
                                    });
                              }));
                    }))
        : SizedBox(
            height: AppVars.screenSize.height,
            child: const Center(
              child: Text("Unauthorized access!"),
            ),
          );
  }
}
