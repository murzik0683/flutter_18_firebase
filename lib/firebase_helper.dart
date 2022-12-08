import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseHelper {
  static Future<bool> login(String email, String password) async {
    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
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

  static Future<bool> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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

  static Stream<DatabaseEvent> getNotes() {
    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id == null) return const Stream.empty();
    final ref = FirebaseDatabase.instance.ref("notes/$id");
    return ref.onValue;
  }

  static Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Utils.showShackBar('Пароль отправлен на Email');
    } on FirebaseAuthException catch (e) {
      print('eeee $e');

      Utils.showShackBar('Введите Email');
      print('e.messagee  ${e.message}');
    }
  }
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
}
