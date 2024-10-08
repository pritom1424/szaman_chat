import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:szaman_chat/utils/components/app_component.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:http/http.dart' as http;
import 'package:szaman_chat/utils/credential/UserCredential.dart';

class GroupChatBubble extends StatelessWidget {
  final String message;
  final String date;
  final bool isMe;
  final String username, userimage;
  final String senderID;

  final bool didImageExist;

  const GroupChatBubble(
      {super.key,
      required this.message,
      required this.date,
      required this.isMe,
      required this.username,
      required this.userimage,
      required this.didImageExist,
      required this.senderID});

  @override
  Widget build(BuildContext context) {
    bool isMyself = (senderID == Usercredential.id) ? true : false;
    Future<Directory?> getDownloadsDirectory() async {
      if (Platform.isAndroid) {
        return Directory('/storage/emulated/0/Download');
      } else {
        return await getApplicationDocumentsDirectory();
      }
    }

    Future<void> downloadFile(String url, String fileName) async {
      final directory = await getDownloadsDirectory();
      if (directory != null) {
        String filePath = '${directory.path}/$fileName';

        // Create HttpClient to download the file
        var response = await http.get(Uri.parse(url));
        var bytes = response.bodyBytes;

        // Write the file
        File file = File(filePath);
        try {
          await file.writeAsBytes(bytes);

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("File downloaded to  $filePath")));
        } catch (e) {}
      }
    }

    bool isImageFormat(String url) {
      // List of common image file formats
      List<String> imageFileFormats = [
        'jpeg',
        'jpg',
        'png',
        'gif',
        'bmp',
        'tiff',
        'tif',
        'webp',
        'heif',
        'heic',
        'svg'
      ];

      // Check if the file format is in the list of image file formats
      return imageFileFormats.contains(AppVars().getFileFormatFromUrl(url));
    }

    bool didshowDate = true;
    if (didImageExist) {}
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment:
            isMyself ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMyself) CircleAvatar(backgroundImage: NetworkImage(userimage)),
          Container(
            width: (didImageExist)
                ? AppVars.screenSize.width * 0.4
                : AppVars.screenSize.width * 0.6,
            decoration: BoxDecoration(
                color: isMyself
                    ? Colors.grey[300]
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMyself
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isMyself
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                )),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: GestureDetector(
              onTap: () {
                didshowDate = !didshowDate;
                // setState(() {}); need handle with state manager
              },
              child: Column(
                crossAxisAlignment: isMyself
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                        color: isMyself
                            ? Colors.black
                            : Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.bold),
                  ),
                  if (didImageExist)
                    (isImageFormat(message))
                        ? InkWell(
                            onTap: () {
                              AppComponent.ZoomImage(context, message);
                            },
                            child: Image.network(
                              message,
                              width: 150,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            child: Column(
                              children: [
                                const Icon(Icons.attach_file),
                                Text(AppVars().getFileNameFromUrl(message)),
                                TextButton(
                                    onPressed: () async {
                                      await downloadFile(
                                          message,
                                          AppVars()
                                                  .getFileNameFromUrl(message) +
                                              AppVars().getFileFormatFromUrl(
                                                  message));
                                    },
                                    child: Text(
                                      "download",
                                      style: TextStyle(
                                          color: (isMe)
                                              ? Colors.blueAccent
                                              : Colors.white),
                                    ))
                              ],
                            ),
                          ),
                  if (!didImageExist)
                    Text(
                      message,
                      maxLines: 50,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: isMyself
                              ? Colors.black
                              : Theme.of(context).colorScheme.onSecondary),
                    ),
                  if (didshowDate)
                    Text(date,
                        style: TextStyle(
                            fontSize: 10,
                            color: isMyself
                                ? Colors.black
                                : Theme.of(context).colorScheme.onSecondary))
                ],
              ),
            ),
          ),
          if (isMyself) CircleAvatar(backgroundImage: NetworkImage(userimage)),
        ],
      ),
    );
  }
}
