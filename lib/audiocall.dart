import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/constants/app_paths.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final appId =
      'f4183852ed674c139ff303c84fcf29e0'; // Replace with your Agora App ID
  // Replace with your Agora App Certificate
  final channelName = 'test_channel';
// Instantiate the client
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: 'f4183852ed674c139ff303c84fcf29e0',
      channelName: 'test_channel',
    ),
  );
  @override
  void initState() {
    super.initState();

    _initializeAgora();
  }

  Future<void> _initializeAgora() async {
    await client.initialize();
    client.engine.disableVideo();

    client.engine.enableAudio();
  }

  @override
  void dispose() {
    // Leave the channel and destroy the engine
    client.engine.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Agora Call'),
      ),
      body: SafeArea(
        child: Container(
          //   color: Colors.black,
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                showAVState: true,
                layoutType: Layout.oneToOne,
              ),
              AgoraVideoButtons(enabledButtons: const [
                BuiltInButtons.callEnd,
              ], client: client),
            ],
          ),
        ),
      ),
    );
  }
}
