import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:szaman_chat/data/models/message_model.dart';

import 'package:szaman_chat/utils/components/app_component.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';

class InputInboxWidget extends StatefulWidget {
  final String fId;
  final String fName;
  final String userUrl;
  final String? folderName;
  final String? imageFolderName;
  final String userName;
  const InputInboxWidget(
      {super.key,
      required this.fId,
      required this.fName,
      required this.userUrl,
      this.folderName,
      this.imageFolderName,
      required this.userName});
  static TextStyle customHintTextStyle = TextStyle(
    color: Colors.grey.withOpacity(0.5),
    fontSize: 15, /* fontFamily: AppStrings.currentFontFamily */
  );

  @override
  State<InputInboxWidget> createState() => _InputInboxWidgetState();
}

class _InputInboxWidgetState extends State<InputInboxWidget> {
  final _controller = TextEditingController();

  String? url;
  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  /*  Future<void> _pictureButtonMethod(File imgFile) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            alignment: Alignment.bottomRight,
            title: const Text(
              "Preview Image",
              textAlign: TextAlign.center,
            ),
            content: Image.file(
              imgFile,
              width: 150,
              height: 100,
              fit: BoxFit.cover,
            ),
            actions: [
              TextButton(
                  onPressed: isPreviewOk
                      ? () {
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: Text("Ok")),
            ],
          );
        });
  } */
  Future<String?> clickOrGetPhoto(ImageSource imgSrc, BuildContext ctx) async {
/*     final imPicker = ImagePicker();
    final imageFile = await imPicker.pickImage(
        source: imgSrc, imageQuality: 75, maxHeight: 700, maxWidth: 700); */

    final imageFile = await AppComponent.clickOrGetPhoto(imgSrc, ctx);

    if (imageFile == null || Usercredential.id == null) {
      return null;
    }

    final ref =
        FirebaseStorage.instanceFor(bucket: "gs://szaman-chat.appspot.com")
            .ref()
            .child(widget.imageFolderName ?? 'chat_images')
            .child(Usercredential.id!)
            .child(imageFile.path.split('/').last);

    await ref.putFile(File(imageFile.path));

    final String url = await ref.getDownloadURL();

    return url;
  }

  Future<String?> getFileUrl() async {
    try {
      var file = await AppComponent.pickFile();
      if (file != null) {
        return await AppComponent.uploadFile(file, widget.folderName);
      } else {
        return null;
      }
    } on Exception {
      // TODO
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, _) {
      void sendMessages() async {
        FocusScope.of(context).unfocus();
        var rp = ref.read(inboxpageViewModel);
        if (rp.IsImageExist == null || url == null || url!.isEmpty) {
          rp.setImageExist(false);
        }
        if (rp.IsImageExist ?? false) {
          ref.read(inboxpageViewModel).setIsDocLoading(true);
        }

        final resultModel = MessageModel(
            createdAt: DateTime.now(),
            message: (rp.IsImageExist!) ? url : _controller.text,
            imageUrl: widget.userUrl,
            isImageExist: rp.IsImageExist ?? false,
            isCalling: false,
            isCallExit: false,
            isVideoOn: false,
            senderID: Usercredential.id!,
            /*   name: Usercredential.name,
            friendName: widget.fName, */
            isME: true);
        ref.read(inboxpageViewModel).setInputText("");
        _controller.clear();
        rp.setImageExist(false);

        url = null;
        await ref.watch(inboxpageViewModel).addMessage(Usercredential.token!,
            resultModel, Usercredential.id!, widget.fId, widget.userName);
        ref.read(inboxpageViewModel).setIsDocLoading(false);
      }

      return Container(
        decoration: AppComponent.customboxDecoration,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  /*      labelText: 'Enter message', */
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  hintStyle: InputInboxWidget.customHintTextStyle,
                  border: InputBorder.none,
                  hintText: 'Enter message',
                ),
                onChanged: (value) {
                  ref.read(inboxpageViewModel).setInputText(value);
                  /*  setState(() {
                                    _enteredMessages = value;
                                    //   value = "";
                                  }); */
                },
              ),
            ),
            IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                ref.read(inboxpageViewModel).setImagePicking(true);
                url = await getFileUrl();
                (url == null)
                    ? ref.read(inboxpageViewModel).setImageExist(false)
                    : ref.read(inboxpageViewModel).setImageExist(true);
                ref.read(inboxpageViewModel).setImagePicking(false);
                // clickOrGetPhoto(ImageSource.camera);
              },
              icon: const Icon(Icons.attach_file),
            ),
            IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                ref.read(inboxpageViewModel).setImagePicking(true);
                url = await clickOrGetPhoto(ImageSource.camera, ctx);
                (url == null)
                    ? ref.read(inboxpageViewModel).setImageExist(false)
                    : ref.read(inboxpageViewModel).setImageExist(true);
                ref.read(inboxpageViewModel).setImagePicking(false);
                // clickOrGetPhoto(ImageSource.camera);
              },
              icon: const Icon(Icons.camera_alt_rounded),
            ),
            IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                ref.read(inboxpageViewModel).setImagePicking(true);
                url = await clickOrGetPhoto(ImageSource.gallery, ctx);
                (url == null)
                    ? ref.read(inboxpageViewModel).setImageExist(false)
                    : ref.read(inboxpageViewModel).setImageExist(true);
                ref.read(inboxpageViewModel).setImagePicking(false);
                // clickOrGetPhoto(ImageSource.gallery);
              },
              icon: const Icon(Icons.photo),
            ),
            IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: ((ref.watch(inboxpageViewModel).inputText.isNotEmpty &&
                          ref.watch(inboxpageViewModel).inputText != "" ||
                      (ref.read(inboxpageViewModel).IsImageExist != null &&
                          ref
                              .read(inboxpageViewModel)
                              .IsImageExist!)) /* ||
                      didImageExist */
                  )
                  ? sendMessages
                  : null,
              icon: (ref.read(inboxpageViewModel).isImagePicking)
                  ? const CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.transparent,
                      child: FittedBox(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : const Icon(Icons.send),
            )
          ],
        ),
      );
    }); //;
  }
}
