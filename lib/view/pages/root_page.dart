import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/provider/navpage_vm.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/pages/auth/login_page.dart';
import 'package:szaman_chat/view/pages/nav_page.dart';

class RootPage extends ConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: ref.read(authViewModel).tryAutoLogin(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                height: AppVars.screenSize.height,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          return (snap.data == true) ? NavPage() : LoginForm();
        });
  }
}
