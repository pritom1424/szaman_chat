import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';

import 'package:szaman_chat/view/widgets/coworkerlist/cwlist_widget.dart';

class CoworkerlistPage extends ConsumerWidget {
  final String? title;
  const CoworkerlistPage({super.key, this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: (title != null)
            ? AppBar(
                title: const Text("Coworkers"),
              )
            : null,
        floatingActionButton:
            (Usercredential.token == null || Usercredential.id == null)
                ? null
                : FutureBuilder(
                    future: ref
                        .read(profileViewModel)
                        .getInfo(Usercredential.token!, Usercredential.id!),
                    builder: (ctx, snap) =>
                        (snap.connectionState == ConnectionState.waiting ||
                                !snap.hasData)
                            ? const SizedBox.shrink()
                            : (snap.data!.isAdmin ?? false)
                                ? FloatingActionButton(
                                    onPressed: () async {
                                      /*  await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (ctx) => const RegistrationForm(
                                            title: "Add Member",
                                          ))); */
                                    },
                                    child: const Icon(Icons.person_add_alt),
                                  )
                                : const SizedBox.shrink(),
                  ),
        body: (Usercredential.token == null)
            ? SizedBox(
                height: AppVars.screenSize.height,
                child: const Center(
                  child: Text("Unauthorized Access!"),
                ),
              )
            : FutureBuilder(
                future: ref
                    .read(inboxpageViewModel)
                    .getFriendIDs(Usercredential.id!),
                builder: (ctx, snapFid) =>
                    (snapFid.connectionState == ConnectionState.waiting)
                        ? SizedBox.shrink()
                        : (!snapFid.hasData)
                            ? SizedBox.shrink()
                            : FutureBuilder(
                                future: ref
                                    .read(userViewModel)
                                    .getInfo(Usercredential.token!),
                                builder: (ctx, snap) {
                                  if (snap.connectionState ==
                                      ConnectionState.waiting) {
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
                                  return CwlistWidget(
                                    uModel: snap.data!,
                                    fid: snapFid.data,
                                  );
                                }),
              ));
  }
}
