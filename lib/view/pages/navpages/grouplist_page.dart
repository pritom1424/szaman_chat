import 'package:flutter/material.dart';
import 'package:szaman_chat/view/widgets/grouplist/grouplist_widget.dart';

class GroupListPage extends StatelessWidget {
  final String? title;
  const GroupListPage({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (title != null)
          ? AppBar(
              title: const Text("Szaman Chat"),
            )
          : null,
      body: const GrouplistWidget(),
    );
  }
}
