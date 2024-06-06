import 'package:flutter/material.dart';
import 'package:szaman_chat/utils/components/app_component.dart';

class InputInboxWidget extends StatelessWidget {
  const InputInboxWidget({super.key});
  static TextStyle customHintTextStyle = TextStyle(
    color: Colors.grey.withOpacity(0.5),
    fontSize: 15, /* fontFamily: AppStrings.currentFontFamily */
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppComponent.customboxDecoration,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              //  controller: _controller,
              decoration: InputDecoration(
                /*      labelText: 'Enter message', */
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                hintStyle: customHintTextStyle,
                /* prefixIcon: Icon(
                  Icons.abc,
                  color: iconColor,
                ), */
                border: InputBorder.none,
                hintText: 'Enter message',
                // labelStyle: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              onChanged: (value) {
                /*  setState(() {
                                  _enteredMessages = value;
                                  //   value = "";
                                }); */
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              // clickOrGetPhoto(ImageSource.camera);
            },
            icon: const Icon(Icons.camera_alt_rounded),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              // clickOrGetPhoto(ImageSource.gallery);
            },
            icon: const Icon(Icons.photo),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: null,
            /*  (_controller.text.isNotEmpty || didImageExist)
                                    ? _sendMessages
                                    : null, */
            icon: const Icon(Icons.send),
          )
        ],
      ),
    ); //;
  }
}
