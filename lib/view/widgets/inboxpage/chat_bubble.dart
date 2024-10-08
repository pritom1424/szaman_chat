import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:szaman_chat/utils/components/app_component.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:http/http.dart' as http;
import 'package:szaman_chat/utils/constants/app_methods.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final DateTime dateTime;
  final bool isMe;
  final String username, userimage;

  final bool didImageExist;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.dateTime,
      required this.isMe,
      required this.username,
      required this.userimage,
      required this.didImageExist});

  @override
  Widget build(BuildContext context) {
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
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) CircleAvatar(backgroundImage: NetworkImage(userimage)),
          Container(
            width: (didImageExist)
                ? AppVars.screenSize.width * 0.4
                : AppVars.screenSize.width * 0.6,
            decoration: BoxDecoration(
                color: isMe
                    ? Colors.grey[300]
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isMe
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
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                        color: isMe
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
                          color: isMe
                              ? Colors.black
                              : Theme.of(context).colorScheme.onSecondary),
                    ),
                  if (didshowDate)
                    Row(
                      children: [
                        Text(AppMethods().timeFormatter(dateTime),
                            style: TextStyle(
                                fontSize: 10,
                                color: isMe
                                    ? Colors.black
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSecondary)),
                        const Spacer(),
                        Text(AppMethods().dateFormatter(dateTime),
                            style: TextStyle(
                                fontSize: 10,
                                color: isMe
                                    ? Colors.black
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSecondary)),
                      ],
                    )
                ],
              ),
            ),
          ),
          if (isMe) CircleAvatar(backgroundImage: NetworkImage(userimage)),
        ],
      ),
    );
  }
}
