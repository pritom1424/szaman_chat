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
  bool didImageExist = true;
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
/*  void clickOrGetPhoto(ImageSource imgSrc) async {
    final imPicker = ImagePicker();
    final imageFile = await imPicker.pickImage(
        source: imgSrc, imageQuality: 75, maxHeight: 700, maxWidth: 700);

    if (imageFile == null) {
      return;
    }

    final ref = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child(imageFile.name);

    await ref.putFile(File(imageFile.path));

    url = await ref.getDownloadURL();
    print('urlis: $url');

    setState(() {
      didImageExist = true;
    });

    print('didImageExist: $didImageExist');
  } */

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, _) {
      print("url len code:${widget.userUrl}");
      void _sendMessages() {
        final resultModel = MessageModel(
            createdAt: DateTime.now(),
            message: _controller.text,
            imageUrl: widget.userUrl,
            isImageExist: false,
            isDeleted: false,
            name: Usercredential.name,
            friendName: widget.fName,
            isME: true);
        ref.watch(inboxpageViewModel).addMessage(
            Usercredential.token!, resultModel, Usercredential.id!, widget.fId);
        FocusScope.of(context).unfocus();
        ref.read(inboxpageViewModel).setInputText("");
        _controller.clear();
      }

      return Container(
        decoration: AppComponent.customboxDecoration,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                final fl =
                    await AppComponent.clickOrGetPhoto(ImageSource.camera, ctx);
                (fl == null) ? didImageExist = true : didImageExist = false;
                // clickOrGetPhoto(ImageSource.camera);
              },
              icon: const Icon(Icons.camera_alt_rounded),
            ),
            IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                final fl = await AppComponent.clickOrGetPhoto(
                    ImageSource.gallery, ctx);
                (fl == null) ? didImageExist = false : didImageExist = true;
                // clickOrGetPhoto(ImageSource.gallery);
              },
              icon: const Icon(Icons.photo),
            ),
            IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: ((ref.watch(inboxpageViewModel).inputText.isNotEmpty &&
                      ref.watch(inboxpageViewModel).inputText !=
                          "") /* ||
                      didImageExist */
                  )
                  ? _sendMessages
                  : null,
              icon: const Icon(Icons.send),
            )
          ],
        ),
      );
    }); //;
  }
}
