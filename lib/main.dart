import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:szaman_chat/utils/components/app_component.dart';

import 'package:szaman_chat/view/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAcHQuKlLrw59V6hD96CxEzqhjSj94LmJA",
          appId: "1:434564582098:android:fdec4b070aca961bbd3b0b",
          messagingSenderId: "434564582098",
          projectId: "szaman-chat"));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo', theme: AppComponent.theme, home: SplashScreen());
  }
}
