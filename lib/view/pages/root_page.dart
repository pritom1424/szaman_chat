import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/pages/auth/login_page_phone.dart';
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
              body: SizedBox(
                height: AppVars.screenSize.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          return (snap.data != null && snap.data!)
              ? const NavPage()
              : const LoginPhoneForm(); //const LoginForm();
        });
  }
}
