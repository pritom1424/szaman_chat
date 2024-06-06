import 'package:flutter/material.dart';
import 'package:szaman_chat/view/widgets/chatlist/chatlist_widget.dart';

class ChatListPage extends StatelessWidget {
  final String? title;
  const ChatListPage({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (title != null)
          ? AppBar(
              title: Text("Szaman Chat"),
            )
          : null,
      body: ChatlistWidget(),
    );
  }
}
