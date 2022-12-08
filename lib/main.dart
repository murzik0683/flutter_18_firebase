import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_18_firebase/firebase_helper.dart';
import 'package:flutter_18_firebase/firebase_options.dart';
import 'package:flutter_18_firebase/login_screen.dart';
import 'package:flutter_18_firebase/profile_screen.dart';
import 'package:flutter_18_firebase/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginScreen(),
        '/sign_up': (_) => SignUpScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}
