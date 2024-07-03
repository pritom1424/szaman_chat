import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';

import 'package:szaman_chat/view/widgets/grouplist/groupcwlist_widget.dart';

class GroupCoworkerlistPage extends ConsumerWidget {
  final String? title;
  final String? gName;
  final String? gID;
  const GroupCoworkerlistPage(
    this.gName,
    this.gID, {
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: (title != null)
            ? AppBar(
                title: Text(title ?? "Groups"),
              )
            : null,
        body: (Usercredential.token == null)
            ? SizedBox(
                height: AppVars.screenSize.height,
                child: const Center(
                  child: Text("Unauthorized Access!"),
                ),
              )
            : FutureBuilder(
                future: ref.read(inboxpageGroupViewModel).getGroupMembers(gID!),
                builder: (ctx, snapFid) => FutureBuilder(
                    future:
                        ref.read(userViewModel).getInfo(Usercredential.token!),
                    builder: (ctx, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: AppVars.screenSize.height,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (!snap.hasData) {
                        return SizedBox(
                          height: AppVars.screenSize.height,
                          child: const Center(
                            child: Text("No User found!"),
                          ),
                        );
                      }

                      return GroupCwlistWidget(
                        uModel: snap.data!,
                        fid: snapFid.data,
                        gName: gName,
                        gID: gID,
                      );
                    }),
              ));
  }
}
