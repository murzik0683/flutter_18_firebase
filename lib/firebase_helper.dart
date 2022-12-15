import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_18_firebase/login_screen.dart';
import 'package:flutter_18_firebase/sign_up_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FirebaseHelper {
  static Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Utils.showShackBarTrue('Login Successful');
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      // Код ошибка для случая, если пользователь не найден
      if (e.code == 'user-not-found') {
        Utils.showShackBar("Unknown user");
        print("Unknown user");
        // Код ошибка для случая, если пользователь ввёл неверный пароль
      } else if (e.code == 'wrong-password') {
        Utils.showShackBar("Wrong password");
        print("Wrong password");
      }
    } catch (e) {
      Utils.showShackBar("Unknown error");

      print("Unknown error");
    }
    return false;
  }

  static Future<bool> signUp(
      String email, String password, String name, String number) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(name);
      userCredential.user?.phoneNumber;

      Utils.showShackBarTrue('Register Successful');
      //Get.offAll(() => const LoginScreen());
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utils.showShackBar('The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Utils.showShackBar('The account already exists for that email.');
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        Utils.showShackBar('Invalid email address.');
        print('Invalid email address.');
      }
    } catch (e) {
      Utils.showShackBar('Неизвестная ошибка');
      print(e);
    }
    return false;
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> write(String note) async {
    // Берём id пользователя, чтобы у каждого пользователя была своя ветка
    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id == null) return;
    // Берём ссылку на корень дерева с записями для текущего пользователя
    final ref = FirebaseDatabase.instance.ref("notes/$id");
    // Сначала генерируем новую ветку с помощью push() и потом в эту же ветку
    // добавляем запись
    await ref.push().set(note);
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////
  // static Future<void> updateNote(String newNote, String title) async {
  //   final id = FirebaseAuth.instance.currentUser?.uid;

  //   // A post entry.
  //   final postData = {
  //     'notes': newNote,
  //   };

  //   // Get a key for a new Post.
  //   final newPostKey =
  //       FirebaseDatabase.instance.ref().child("notes/$id").push().key;

  //   // Write the new post's data simultaneously in the posts list and the
  //   // user's post list.
  //   final Map<String, Map> updates = {};
  //   updates['notes/$id/$newPostKey'] = postData;

  //   return FirebaseDatabase.instance.ref().update(updates);
  // }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  static Stream<DatabaseEvent> getNotes() {
    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id == null) return const Stream.empty();
    final ref = FirebaseDatabase.instance.ref("notes/$id");
    return ref.onValue;
  }

  static Future<void> delete(String note) async {
    final id = FirebaseAuth.instance.currentUser?.uid;
    final notes = await FirebaseDatabase.instance.ref("notes/$id").get();

    for (var i in notes.children) {
      if ((i.value) == note) {
        i.ref.remove();
      }
    }
  }

  // static Future<void> delete2(String note) async {
  //   final id = FirebaseAuth.instance.currentUser?.uid;
  //   final notes = await FirebaseDatabase.instance.ref("notes/$id").get();
  //   notes.children.forEach((element) {
  //     if ((element.value as String?) == note) {
  //       element.ref.remove();
  //     }
  //   });
  // }

  static Future<void> resetPassword(String email, context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Utils.showShackBarTrue('Пароль отправлен на Email');
      Utils.showDialog(context);
    } on FirebaseAuthException catch (e) {
      print('eeee $e');

      Utils.showShackBar('Email Invalid');
      print('e.messagee  ${e.message}');
    }
  }

  static Future<void> writeMessage(String message) async {
    final ref = FirebaseDatabase.instance.ref("message");
    await ref.set(message);
  }

  static Stream<DatabaseEvent> readMessage() =>
      FirebaseDatabase.instance.ref("message").onValue;
}

final messengerKey = GlobalKey<ScaffoldMessengerState>();

class Utils {
  static showShackBar(String? text) {
    if (text == null) return;
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static showShackBarTrue(String? text) {
    if (text == null) return;
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.green,
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static showDialog(context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (_, __, ___) {
        return AlertDialog(
          title: const Text('Successful!'),
          content: TextButton(
            onPressed: () {
              Get.offAll(() => const LoginScreen());
            },
            child: const Text('L O G I N'),
          ),
        );
      },
    );
  }
}
