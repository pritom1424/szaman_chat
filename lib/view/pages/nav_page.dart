import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/constants/data.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/pages/navpages/chatlist_page.dart';
import 'package:szaman_chat/view/pages/navpages/coworkerlist_page.dart';
import 'package:szaman_chat/view/pages/navpages/grouplist_page.dart';
import 'package:szaman_chat/view/pages/navpages/profile_page.dart';

import 'package:szaman_chat/view/widgets/navpage/navbar_widget.dart';

class NavPage extends ConsumerWidget {
  const NavPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /*  List<String> navPageTitles = ["Szaman Chat", "Group Chat", "My Profile"]; */

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
      appBar: AppBar(
        foregroundColor: Colors.white,
        // automaticallyImplyLeading: true,
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
      ),
      bottomNavigationBar: NavBarWidget(
        currentIndex: ref.read(navpageViewModel).selectIndex,
        onTap: ref.watch(navpageViewModel).setIndex,
      ),
      body: navViews()[ref.read(navpageViewModel).selectIndex],
    );
  }
}
