import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/constants/app_methods.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/widgets/chatlist/chatlist_template.dart';

class ChatlistWidget extends ConsumerWidget {
  const ChatlistWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return (Usercredential.id != null || Usercredential.token != null)
        ? FutureBuilder(
            future:
                ref.read(inboxpageViewModel).getFriendIDs(Usercredential.id!),
            builder: (ctx, snapId) {
              if (snapId.connectionState == ConnectionState.waiting) {
                return Container(
                  height: AppVars.screenSize.height,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (!snapId.hasData) {
                return const SizedBox.shrink();
              }
              print("id print ${snapId.data!.length}");
              return ListView.builder(
                  itemCount: snapId.data!.length,
                  itemBuilder: (ctx, ind) => FutureBuilder(
                      future: ref
                          .read(profileViewModel)
                          .getInfo(Usercredential.token!, snapId.data![ind]),
                      builder: (context, snapPhoto) {
                        if (!snapPhoto.hasData) {
                          print("photo print");
                          return const SizedBox.shrink();
                        }
                        print("photo print success");
                        return FutureBuilder(
                            future: ref.read(inboxpageViewModel).getAllMessages(
                                Usercredential.token!,
                                Usercredential.id!,
                                snapId.data![ind]), //fID
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                      ConnectionState.waiting &&
                                  ind == 1) {
                                return Container(
                                  height: AppVars.screenSize.height * 0.8,
                                  child: Center(
                                    child: Text("Loading..."),
                                  ),
                                );
                              }
                              if (!snap.hasData) {
                                return const SizedBox.shrink();
                              }
                              print(
                                  "message print success  ${Usercredential.token!})");

                              return FutureBuilder(
                                  future: ref
                                      .read(userViewModel)
                                      .getInfo(Usercredential.token!),
                                  builder: (ctx, snapUsers) {
                                    if (!snapUsers.hasData) {
                                      return const SizedBox.shrink();
                                    }
                                    return ChatListTemplet(
                                        snapId.data![ind],
                                        snapUsers.data![Usercredential.id]
                                                ?.name ??
                                            "user",
                                        /*     /* snap.data![0].name ??  */ "user", */
                                        snap.data!.last.message ?? "message",
                                        AppMethods().dateFormatter(
                                            snap.data!.last.createdAt),
                                        snapPhoto.data!.imageUrl!,
                                        false,
                                        snap.data!.last.isME,
                                        snapUsers.data![snapId.data![ind]]
                                                ?.name ??
                                            "friends"
                                        // data[ind]["isSeen"]
                                        );
                                  });
                            });
                      }));
            },
          )
        : SizedBox(
            height: AppVars.screenSize.height,
            child: const Center(
              child: Text("Unauthorized access!"),
            ),
          );
  }
}
