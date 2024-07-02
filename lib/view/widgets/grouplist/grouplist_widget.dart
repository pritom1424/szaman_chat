import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/data/models/message_model.dart';
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

                              return ListView.builder(
                                  reverse: false,
                                  itemCount: snapId.data!.length,
                                  itemBuilder: (ctx, ind) => FutureBuilder(
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
                                              AppPaths.callStartSoundPath);
                                        } else {
                                          SoundManager().stopSound();
                                        }

                                        return FutureBuilder(
                                            future: ref
                                                .read(inboxpageGroupViewModel)
                                                .getGroupNameById(
                                                    snapId.data![ind]),
                                            builder: (ctx, snapGroupName) {
                                              if (!snapGroupName.hasData) {
                                                return const SizedBox.shrink();
                                              }

                                              return StreamBuilder(
                                                  stream: ref
                                                      .read(
                                                          inboxpageGroupViewModel)
                                                      .isLastMessageSeenStream(
                                                          snapId.data![ind]),
                                                  builder: (ctx, snapIsSeen) {
                                                    if (!snapIsSeen.hasData) {
                                                      return const SizedBox
                                                          .shrink();
                                                    }
                                                    bool isEmpty = false;
                                                    MessageModel? mModel;
                                                    if (snapIsSeen
                                                        .data!.isEmpty) {
                                                      isEmpty = true;
                                                    } else {
                                                      mModel = snapIsSeen
                                                              .data!['message']
                                                          as MessageModel;
                                                    }

                                                    //groupList.reversed.toList();
                                                    return FutureBuilder(
                                                        future: ref
                                                            .read(
                                                                inboxpageViewModel)
                                                            .getCallStatus(),
                                                        builder: (context,
                                                            snapCall) {
                                                          if (!snapCall
                                                              .hasData) {
                                                            const SizedBox
                                                                .shrink();
                                                          }

                                                          if (snapCall.data ==
                                                              1) {
                                                            print(
                                                                "is call when calling...");
                                                            SoundManager()
                                                                .playSound(AppPaths
                                                                    .callStartSoundPath);
                                                          }
                                                          if (snapCall.data ==
                                                              0) {
                                                            SoundManager()
                                                                .stopSound();
                                                          }
                                                          return GroupListTemplet(
                                                            snapId.data!
                                                                .toList()[ind],
                                                            snapGroupName.data!,
                                                            (isEmpty)
                                                                ? "welcome!"
                                                                : mModel?.message ??
                                                                    "welcome",
                                                            AppMethods()
                                                                .dateFormatter(
                                                                    DateTime
                                                                        .now()), //   snap.data?.last.createdAt ??
                                                            (isEmpty)
                                                                ? false
                                                                : snapIsSeen.data![
                                                                        'communicate'] ??
                                                                    true,
                                                            (isEmpty)
                                                                ? true
                                                                : mModel?.isME ??
                                                                    true,
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
