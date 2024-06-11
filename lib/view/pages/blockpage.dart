import 'package:flutter/material.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';

class Blockpage extends StatelessWidget {
  const Blockpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Szaman Chat"),
        automaticallyImplyLeading: false,
      ),
      body: SizedBox(
        height: AppVars.screenSize.height,
        child: Center(
          child: Text("You have been blocked!"),
        ),
      ),
    );
  }
}
