import 'dart:async';

import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/components/custom_clock.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';

class CallScreen extends StatefulWidget {
  final String channelName;
  final String fid;
  final String imageURL;
  const CallScreen(
      {super.key,
      required this.channelName,
      required this.fid,
      required this.imageURL});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final appId = 'f4183852ed674c139ff303c84fcf29e0';
  DateFormat formatter = DateFormat('HH:mm:ss');

  late Timer timer;
  String timeString = "00:00:00";
  final customTimer = CustomTimer();
  // Replace with your Agora App ID
  // Replace with your Agora App Certificate

// Instantiate the client
  late AgoraClient client;
  @override
  void initState() {
    super.initState();

    _initializeAgora();
  }

  Future<void> _initializeAgora() async {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (client.users.length > 0) {
        customTimer.incrementTime();
      }
    });

    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: 'f4183852ed674c139ff303c84fcf29e0',
        channelName: widget.channelName,
      ),
    );
    await client.initialize();
    client.engine.disableVideo();
//client.users.length

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
    print("channel name" + widget.channelName);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Audio Call'),
      ),
      body: Consumer(
        builder: (ctx, ref, _) => StreamBuilder(
            stream: ref.read(inboxpageViewModel).getAllMessagesStream(
                Usercredential.token!, Usercredential.id!, widget.fid),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink();
              }
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }
              if (snapshot.data!.last.isCalling == false &&
                  snapshot.data!.last.isCallExit == true) {
                Navigator.of(context).pop();
                print("leave Channel");
              }
              return Container(
                height: AppVars.screenSize.height,
                //   color: Colors.black,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: AppVars.screenSize.height * 0.1,
                          child: FittedBox(
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(widget.imageURL),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          (client.users.length == 0)
                              ? "Ringing..."
                              : customTimer.formattedTime(),
                          textAlign: TextAlign.center,
                        )
                      ],
                    )

                    /* (widget.channelName == Usercredential.id)
                        ? AgoraVideoViewer(
                            client: client,
                            // showAVState: true,
                            layoutType: Layout.oneToOne,
                            //  showNumberOfUsers: true,
                            disabledVideoWidget: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  child: Text("id"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(customTimer.formattedTime())
                              ],
                            ))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                child: Text("id"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                customTimer.formattedTime(),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ) */
                    ,
                    AgoraVideoButtons(enabledButtons: const [
                      BuiltInButtons.callEnd,
                    ], client: client),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
