import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/utils/audio/sound_manager.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/constants/app_methods.dart';
import 'package:szaman_chat/utils/constants/app_paths.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/widgets/grouplist/grouplist_template.dart';

class GrouplistWidget extends StatelessWidget {
  final bool isLoaded;
  const GrouplistWidget({super.key, required this.isLoaded});

  @override
  Widget build(BuildContext context) {
    final List<GroupListTemplet> groupList = [];
    if (isLoaded) {
      return SizedBox(
        height: AppVars.screenSize.height * 0.8,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Consumer(
        builder: (ctx, ref, _) => (Usercredential.id != null ||
                Usercredential.token != null)
            ? FutureBuilder(
                future: ref.read(userViewModel).getInfo(Usercredential.token!),
                builder: (ctx, snapUsers) => (snapUsers.connectionState ==
                        ConnectionState.waiting)
                    ? const SizedBox.shrink()
                    : FutureBuilder(
                        future: ref
                            .read(profileViewModel)
                            .getInfo(Usercredential.token!, Usercredential.id!),
                        builder: (context, snapUserProfile) {
                          if (snapUserProfile.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              height: AppVars.screenSize.height,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          return FutureBuilder(
                            future: ref
                                .read(inboxpageGroupViewModel)
                                .getGroupIDs(Usercredential.id!),
                            builder: (ctx, snapId) {
                              if (snapId.connectionState ==
                                  ConnectionState.waiting) {
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
                                    "No group added till now!\n Add some!",
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                              print("id print ${snapId.data!.length}");

                              return ListView.builder(
                                  reverse: false,
                                  itemCount: snapId.data!.length,
                                  itemBuilder: (ctx, ind) => StreamBuilder(
                                      /* future: ref
                                          .read(inboxpageGroupViewModel)
                                          .getAllMessages(Usercredential.token!,
                                              snapId.data![ind]), */ //fID
                                      stream: ref
                                          .read(inboxpageGroupViewModel)
                                          .getAllMessagesStream(
                                              Usercredential.token!,
                                              snapId.data![ind]),
                                      builder: (context, snap) {
                                        if (!snap.hasData) {
                                          return const SizedBox.shrink();
                                        }

                                        return FutureBuilder(
                                            future: ref
                                                .read(inboxpageViewModel)
                                                .getCallStatus(),
                                            builder: (context, snapCall) {
                                              if (!snapCall.hasData) {
                                                SizedBox.shrink();
                                              }
                                              if (snapCall.data == 1) {
                                                SoundManager().playSound(
                                                    AppPaths
                                                        .callStartSoundPath);
                                              }
                                              if (snapCall.data == 0) {
                                                SoundManager().stopSound();
                                              }

                                              return FutureBuilder(
                                                  future: ref
                                                      .read(
                                                          inboxpageGroupViewModel)
                                                      .getGroupNameById(
                                                          snapId.data![ind]),
                                                  builder:
                                                      (ctx, snapGroupName) {
                                                    if (!snapGroupName
                                                        .hasData) {
                                                      return const SizedBox
                                                          .shrink();
                                                    }
                                                    bool isEmpty = false;
                                                    if (snap.data!.isEmpty) {
                                                      isEmpty = true;
                                                    }

                                                    return FutureBuilder(
                                                        future: ref
                                                            .read(
                                                                inboxpageGroupViewModel)
                                                            .islastMessageSeen(
                                                                snapId.data![
                                                                    ind]),
                                                        builder:
                                                            (ctx, snapIsSeen) {
                                                          //groupList.reversed.toList();
                                                          return GroupListTemplet(
                                                            snapId.data!
                                                                .toList()[ind],
                                                            snapGroupName.data!,
                                                            (isEmpty)
                                                                ? "welcome!"
                                                                : snap
                                                                    .data
                                                                    ?.last
                                                                    .message,
                                                            AppMethods()
                                                                .dateFormatter(
                                                                    DateTime
                                                                        .now()), //   snap.data?.last.createdAt ??
                                                            (isEmpty)
                                                                ? false
                                                                : snapIsSeen
                                                                        .data ??
                                                                    true,
                                                            (isEmpty)
                                                                ? true
                                                                : snap.data!
                                                                    .last.isME,
                                                            userimageUrl:
                                                                snapUserProfile
                                                                    .data!
                                                                    .imageUrl!,
                                                            userModel:
                                                                snapUsers.data!,
                                                          );
                                                        });
                                                  });
                                            });
                                      }));
                            },
                          );
                        }),
              )
            : SizedBox(
                height: AppVars.screenSize.height,
                child: const Center(
                  child: Text("Unauthorized access!"),
                ),
              ));
  }
}
