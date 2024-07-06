import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:szaman_chat/utils/components/app_component.dart';
import 'package:szaman_chat/utils/constants/app_constant.dart';

import 'package:szaman_chat/view/pages/splash_screen.dart';

late final FirebaseAuth auth;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*  FirebaseMessaging.onBackgroundMessage(
      FirebasePush().repeatIncomingCallNotification); */
  final app = await Firebase.initializeApp(options: AppConstant.firebaseOption);

  auth = FirebaseAuth.instanceFor(app: app);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*  if (!notifyStat.isGranted) {
      FirebasePush().showNotification(contex);
    } */
    return MaterialApp(
        title: 'Flutter Demo',
        theme: AppComponent.theme,
        home: const SplashScreen()); //const CallScreen()); //
  }
}
