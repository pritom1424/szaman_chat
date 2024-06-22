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
  const InputInboxWidget(
      {super.key,
      required this.fId,
      required this.fName,
      required this.userUrl});
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
            .child('chat_images')
            .child(Usercredential.id!)
            .child(imageFile.path.split('/').last);

    await ref.putFile(File(imageFile.path));

    final String url = await ref.getDownloadURL();
    print('urlis: $url');

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, _) {
      void sendMessages() async {
        var rp = ref.read(inboxpageViewModel);
        if (rp.IsImageExist == null || url == null || url!.isEmpty) {
          print("eneteredd");
          rp.setImageExist(false);
        }
        print("enetered1 ${rp.IsImageExist}");
        final resultModel = MessageModel(
            createdAt: DateTime.now(),
            message: rp.IsImageExist! ? url : _controller.text,
            imageUrl: widget.userUrl,
            isImageExist: rp.IsImageExist ?? false,
            isDeleted: false,
            senderID: Usercredential.id!,
            /*   name: Usercredential.name,
            friendName: widget.fName, */
            isME: true);
        ref.read(inboxpageViewModel).setInputText("");
        _controller.clear();
        rp.setImageExist(false);
        url = null;
        await ref.watch(inboxpageViewModel).addMessage(
            Usercredential.token!, resultModel, Usercredential.id!, widget.fId);
        FocusScope.of(context).unfocus();
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
                url = await clickOrGetPhoto(ImageSource.camera, ctx);
                (url == null)
                    ? ref.read(inboxpageViewModel).setImageExist(false)
                    : ref.read(inboxpageViewModel).setImageExist(true);
                // clickOrGetPhoto(ImageSource.camera);
              },
              icon: const Icon(Icons.camera_alt_rounded),
            ),
            IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                url = await clickOrGetPhoto(ImageSource.gallery, ctx);
                (url == null)
                    ? ref.read(inboxpageViewModel).setImageExist(false)
                    : ref.read(inboxpageViewModel).setImageExist(true);
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
              icon: const Icon(Icons.send),
            )
          ],
        ),
      );
    }); //;
  }
}
