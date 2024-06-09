import 'package:flutter/material.dart';
import 'package:szaman_chat/view/widgets/chatlist/chatlist_widget.dart';
import 'package:szaman_chat/view/widgets/coworkerlist/cwlist_widget.dart';

class CoworkerlistPage extends StatelessWidget {
  final String? title;
  const CoworkerlistPage({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (title != null)
            ? AppBar(
                title: Text("Coworkers"),
              )
            : null,
        body: CwlistWidget());
  }
}
