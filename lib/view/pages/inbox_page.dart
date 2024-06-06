import 'package:flutter/material.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/constants/app_colors.dart';
import 'package:szaman_chat/view/widgets/inboxpage/inbox_messages_widget.dart';
import 'package:szaman_chat/view/widgets/inboxpage/input_inbox_widget.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inbox"),
      ),
      body: Container(
        width: double.infinity,
        color: Color.fromARGB(255, 226, 204, 195),
        child: Column(
          children: [
            Expanded(child: InboxMessagesWidget()),
            InputInboxWidget()
          ],
        ),
      ),
    );
  }
}
