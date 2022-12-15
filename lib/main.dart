import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_18_firebase/firebase_helper.dart';
import 'package:flutter_18_firebase/firebase_options.dart';
import 'package:flutter_18_firebase/login_screen.dart';
import 'package:flutter_18_firebase/notification_firebase.dart';
import 'package:flutter_18_firebase/profile_screen.dart';
import 'package:flutter_18_firebase/profile_screen_storage.dart';
import 'package:flutter_18_firebase/sign_up_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Проверяем залогинен ли пользователь
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      runApp(const MyApp(auth: false));
    } else {
      runApp(const MyApp(auth: true));
    }
  });
  //runApp(const MyApp());

////// notification
  FirebaseMessaging.onBackgroundMessage(firebaseMessaging);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channelFire);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       scaffoldMessengerKey: messengerKey,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute: '/login',
//       routes: {
//         '/login': (_) => LoginScreen(),
//         '/sign_up': (_) => SignUpScreen(),
//         '/profile': (_) => const ProfileScreen(),
//       },
//     );
//   }
// }
class MyApp extends StatelessWidget {
  final bool auth;
  const MyApp({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Get.key,
      scaffoldMessengerKey: messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Хранение данных',
      home: Scaffold(
        body: auth ? const ProfileScreen() : const LoginScreen(),
      ),
    );
  }
}
