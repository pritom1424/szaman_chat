import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/pages/navpages/chatlist_page.dart';
import 'package:szaman_chat/view/pages/navpages/grouplist_page.dart';

import 'package:szaman_chat/view/widgets/navpage/navbar_widget.dart';

class NavPage extends ConsumerWidget {
  const NavPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> navPageTitles = ["Szaman Chat", "Group Chat"];

    List<Widget?> navViews() {
      return [ChatListPage(), GroupListPage()];
    }

    AppVars.screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(navPageTitles[ref.read(navpageViewModel).selectIndex]),
      ),
      bottomNavigationBar: NavBarWidget(
        currentIndex: ref.read(navpageViewModel).selectIndex,
        onTap: ref.watch(navpageViewModel).setIndex,
      ),
      body: navViews()[ref.read(navpageViewModel).selectIndex],
    );
  }
}
