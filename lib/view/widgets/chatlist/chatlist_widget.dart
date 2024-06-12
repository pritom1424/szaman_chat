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
              if (!snapId.hasData) {
                return SizedBox.shrink();
              }

              return ListView.builder(
                  itemCount: snapId.data!.length,
                  itemBuilder: (ctx, ind) => FutureBuilder(
                      future: ref
                          .read(profileViewModel)
                          .getInfo(Usercredential.token!, snapId.data![ind]),
                      builder: (context, snapPhoto) {
                        if (!snapPhoto.hasData) {
                          return SizedBox.shrink();
                        }
                        return FutureBuilder(
                            future: ref.read(inboxpageViewModel).getAllMessages(
                                Usercredential.token!,
                                Usercredential.id!,
                                snapId.data![ind]), //fID
                            builder: (context, snap) {
                              if (!snap.hasData) {
                                return SizedBox.shrink();
                              }
                              return ChatListTemplet(
                                snapId.data![ind],
                                snap.data![ind].friendName ?? "user",
                                snap.data![ind].message ?? "message",
                                AppMethods()
                                    .dateFormatter(snap.data![ind].createdAt),
                                snapPhoto.data!.imageUrl!,
                                false, // data[ind]["isSeen"]
                              );
                            });
                      }));
            },
          )
        : SizedBox(
            height: AppVars.screenSize.height,
            child: Center(
              child: Text("Unauthorized access!"),
            ),
          );
  }
}
