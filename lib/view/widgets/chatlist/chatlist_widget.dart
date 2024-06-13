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
                          return SizedBox.shrink();
                        }
                        print("photo print success");
                        return FutureBuilder(
                            future: ref.read(inboxpageViewModel).getAllMessages(
                                Usercredential.token!,
                                Usercredential.id!,
                                snapId.data![ind]), //fID
                            builder: (context, snap) {
                              if (!snap.hasData) {
                                return SizedBox.shrink();
                              }
                              print(
                                  "message print success  ${snap.data!.length}(${snapId.data![ind]})");
                              return ChatListTemplet(
                                  snapId.data![ind],
                                  snap.data![0].name ?? "user",
                                  snap.data![0].message ?? "message",
                                  AppMethods()
                                      .dateFormatter(snap.data![0].createdAt),
                                  snapPhoto.data!.imageUrl!,
                                  false,
                                  snap.data![0].isME,
                                  snap.data![0].friendName ?? "friend"
                                  // data[ind]["isSeen"]
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
