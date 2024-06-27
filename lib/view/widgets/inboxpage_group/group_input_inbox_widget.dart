import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:szaman_chat/data/models/message_model.dart';

import 'package:szaman_chat/utils/components/app_component.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/widgets/inboxpage/input_inbox_widget.dart';

class GroupInputInboxWidget extends StatefulWidget {
  final String gid;
  final String gName;
  final String userUrl;
  final String? folderName;

  const GroupInputInboxWidget({
    super.key,
    required this.gid,
    required this.gName,
    required this.userUrl,
    this.folderName,
  });
  static TextStyle customHintTextStyle = TextStyle(
    color: Colors.grey.withOpacity(0.5),
    fontSize: 15, /* fontFamily: AppStrings.currentFontFamily */
  );

  @override
  State<GroupInputInboxWidget> createState() => _GroupInputInboxWidget();
}

class _GroupInputInboxWidget extends State<GroupInputInboxWidget> {
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
            .child('group_images')
            .child(Usercredential.id!)
            .child(imageFile.path.split('/').last);

    await ref.putFile(File(imageFile.path));

    final String url = await ref.getDownloadURL();
    print('urlis: $url');

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
        var rp = ref.read(inboxpageGroupViewModel);
        if (rp.IsImageExist == null || url == null || url!.isEmpty) {
          rp.setImageExist(false);
        }
        if (rp.IsImageExist ?? false) {
          ref.read(inboxpageGroupViewModel).setIsDocLoading(true);
        }

        final resultModel = MessageModel(
            createdAt: DateTime.now(),
            message: (rp.IsImageExist!) ? url : _controller.text,
            imageUrl: widget.userUrl,
            isImageExist: rp.IsImageExist ?? false,
            isCalling: false,
            isCallExit: false,
            senderID: Usercredential.id!,
            /*   name: Usercredential.name,
            friendName: widget.fName, */
            isME: true);
        ref.read(inboxpageGroupViewModel).setInputText("");
        _controller.clear();
        rp.setImageExist(false);

        url = null;
        await ref.watch(inboxpageGroupViewModel).addMessage(
            Usercredential.token!, resultModel, Usercredential.id!, widget.gid);
        ref.read(inboxpageGroupViewModel).setIsDocLoading(false);
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
                  ref.read(inboxpageGroupViewModel).setInputText(value);
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
                ref.read(inboxpageGroupViewModel).setImagePicking(true);
                url = await getFileUrl();
                (url == null)
                    ? ref.read(inboxpageGroupViewModel).setImageExist(false)
                    : ref.read(inboxpageGroupViewModel).setImageExist(true);
                ref.read(inboxpageGroupViewModel).setImagePicking(false);
                // clickOrGetPhoto(ImageSource.camera);
              },
              icon: const Icon(Icons.attach_file),
            ),
            IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                ref.read(inboxpageGroupViewModel).setImagePicking(true);
                url = await clickOrGetPhoto(ImageSource.camera, ctx);
                (url == null)
                    ? ref.read(inboxpageGroupViewModel).setImageExist(false)
                    : ref.read(inboxpageGroupViewModel).setImageExist(true);
                ref.read(inboxpageGroupViewModel).setImagePicking(false);
                // clickOrGetPhoto(ImageSource.camera);
              },
              icon: const Icon(Icons.camera_alt_rounded),
            ),
            IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                ref.read(inboxpageGroupViewModel).setImagePicking(true);
                url = await clickOrGetPhoto(ImageSource.gallery, ctx);
                (url == null)
                    ? ref.read(inboxpageGroupViewModel).setImageExist(false)
                    : ref.read(inboxpageGroupViewModel).setImageExist(true);
                ref.read(inboxpageGroupViewModel).setImagePicking(false);
                // clickOrGetPhoto(ImageSource.gallery);
              },
              icon: const Icon(Icons.photo),
            ),
            IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: ((ref
                              .watch(inboxpageGroupViewModel)
                              .inputText
                              .isNotEmpty &&
                          ref.watch(inboxpageGroupViewModel).inputText != "" ||
                      (ref.read(inboxpageGroupViewModel).IsImageExist != null &&
                          ref
                              .read(inboxpageGroupViewModel)
                              .IsImageExist!)) /* ||
                      didImageExist */
                  )
                  ? sendMessages
                  : null,
              icon: (ref.read(inboxpageGroupViewModel).isImagePicking)
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
