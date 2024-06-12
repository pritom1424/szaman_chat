import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/constants/data.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/pages/auth/login_page.dart';
import 'package:szaman_chat/view/pages/blockpage.dart';
import 'package:szaman_chat/view/pages/navpages/chatlist_page.dart';
import 'package:szaman_chat/view/pages/navpages/coworkerlist_page.dart';
import 'package:szaman_chat/view/pages/navpages/grouplist_page.dart';
import 'package:szaman_chat/view/pages/navpages/profile_page.dart';

import 'package:szaman_chat/view/widgets/navpage/navbar_widget.dart';

class NavPage extends ConsumerWidget {
  const NavPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget?> navViews() {
      return [
        ChatListPage(),
        GroupListPage(),
        CoworkerlistPage(),
        ProfileForm()
      ];
    }

    AppVars.screenSize = MediaQuery.of(context).size;
    final widthSize = 0.5;
    return Scaffold(
      body: (!ref.read(navpageViewModel).isInit)
          ? FutureBuilder(
              future: ref
                  .read(profileViewModel)
                  .getInfo(Usercredential.token!, Usercredential.id!),
              builder: (ctx, snapProf) {
                if (snapProf.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: AppVars.screenSize.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (!snapProf.hasData) {
                  return Blockpage();
                }
                Usercredential.isAdmin = snapProf.data!.isAdmin;
                ref.read(navpageViewModel).setIsInit(true);
                return mainBody(widthSize, ref, context, navViews);
              })
          : mainBody(widthSize, ref, context, navViews),
    );
  }

  Scaffold mainBody(double widthSize, WidgetRef ref, BuildContext context,
      List<Widget?> navViews()) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leadingWidth: 50,
        title: Container(
          width: AppVars.screenSize.width * (widthSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FittedBox(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: CircleAvatar(
                        child: Icon(Icons.person),
                      ))),
              Text(
                Data.navBarData.entries
                    .toList()[ref.read(navpageViewModel).selectIndex]
                    .key,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await ref.read(authViewModel).logout();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => LoginForm()));
              },
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              label: const Text(
                "logout",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ], //TextButton(onPressed: () {}, child: Text("Logout"))
      ),
      bottomNavigationBar: NavBarWidget(
        currentIndex: ref.read(navpageViewModel).selectIndex,
        onTap: ref.watch(navpageViewModel).setIndex,
      ),
      body: navViews()[ref.read(navpageViewModel).selectIndex],
    );
  }
}
