import 'package:flutter/material.dart';
import 'package:szaman_chat/utils/components/app_component.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String date;
  final bool isMe;
  final String username, userimage;

  final bool didImageExist;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.date,
      required this.isMe,
      required this.username,
      required this.userimage,
      required this.didImageExist});

  @override
  Widget build(BuildContext context) {
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
    if (didImageExist) {
      print("message inbox: $message");
    }
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
                                Icon(Icons.attach_file),
                                Text(AppVars().getFileNameFromUrl(message))
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
                    Text(date,
                        style: TextStyle(
                            fontSize: 10,
                            color: isMe
                                ? Colors.black
                                : Theme.of(context).colorScheme.onSecondary))
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
