import 'dart:async';

import 'package:flutter/material.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/constants/app_paths.dart';
import 'package:szaman_chat/view/pages/root_page.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => RootPage()));
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size scSize = MediaQuery.of(context).size;
    AppVars.screenSize = scSize;
    return Scaffold(
        body: Container(
      height: scSize.height,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LogoAnimation(),
          SizedBox(
            width: scSize.width * 0.5,
            height: scSize.height * 0.2,
            child: Image.asset(
              AppPaths.applogoPath,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    ));
  }
}
