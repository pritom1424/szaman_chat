import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:szaman_chat/utils/constants/app_colors.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';

class AppComponent {
  /// Utility function to create a MaterialColor from a single Color
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  static ThemeData get theme {
    return ThemeData(
      primaryColor: Appcolors.appThemeColor,
      primarySwatch: createMaterialColor(Appcolors.appThemeColor),
      colorScheme: ColorScheme.fromSwatch(
              primarySwatch: createMaterialColor(Appcolors.appThemeColor))
          .copyWith(secondary: Appcolors.steelBlue),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Appcolors.appThemeColor),
        bodyLarge: TextStyle(color: Colors.black),
      ),
      appBarTheme: const AppBarTheme(
          color: Color(0xFFEE7843),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFFEE7843),
        textTheme: ButtonTextTheme.primary,
      ),
      dialogTheme: const DialogTheme(backgroundColor: Colors.white),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFEE7843),
      ),
      scaffoldBackgroundColor: Appcolors.offwhite,
    );
  }

  static void ZoomImage(BuildContext ctx, String Url) {
    final ScrSize = MediaQuery.of(ctx).size;
    showDialog(
        barrierDismissible: true,
        context: ctx,
        builder: (ctx) => AlertDialog(content: Builder(builder: (ctx) {
              return SizedBox(
                width: ScrSize.width - 50,
                height: ScrSize.height / 2,
                child: Image.network(Url),
              );
            })));
  }

  static BoxDecoration customboxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20.0),
    border: Border.all(width: 1, color: Colors.white),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.8),
        spreadRadius: 2,
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ],
  );

  static Future<void> pictureButtonMethod(
      File imgFile, BuildContext context) async {
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok")),
            ],
          );
        });
  }

  static Future<File?> clickOrGetPhoto(
      ImageSource imgSrc, BuildContext ctx) async {
    final imPicker = ImagePicker();

    final imageFile = await imPicker.pickImage(
        source: imgSrc, imageQuality: 75, maxHeight: 700, maxWidth: 700);

    if (imageFile == null) {
      return null;
    }

    return File(imageFile.path);
  }

  static Future<PlatformFile?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      return file;
    }
    return null;
  }

  static Future<String?> uploadFile(PlatformFile file) async {
    try {
      if (file.path == null) {
        return null;
      }
      File fileToUpload = File(file.path!);
      FirebaseStorage storage =
          FirebaseStorage.instanceFor(bucket: "gs://szaman-chat.appspot.com");
      Reference ref = storage
          .ref()
          .child('chat_files')
          .child(Usercredential.id!)
          .child(file.path!.split('/').last);
      UploadTask uploadTask = ref.putFile(fileToUpload);

      await uploadTask.whenComplete(() async {
        String downloadURL = await ref.getDownloadURL();
        print("File uploaded successfully. Download URL: $downloadURL");
        return downloadURL;
      });
    } catch (e) {
      print("Failed to upload file: $e");
      return null;
    }
  }

  static Future<File?> selectpictureAlert(BuildContext context) async {
    File? pickedFile;
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
              title: Text(
                'Select/Click Profile Photo!',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              content: Text(
                "Select a method!",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                        onPressed: () async {
                          pickedFile = await clickOrGetPhoto(
                              ImageSource.camera, context);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon(Icons.camera_alt_rounded),
                        label: const Text("Camera")),
                    TextButton.icon(
                        onPressed: () async {
                          pickedFile = await clickOrGetPhoto(
                              ImageSource.gallery, context);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon(Icons.photo),
                        label: const Text("Gallery"))
                  ],
                )
              ],
            ));
    return pickedFile;
  }
}
