import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Канал firebase
const AndroidNotificationChannel channelFire = AndroidNotificationChannel(
  'chanel_id_fire',
  'chanel_title_fire',
  importance: Importance.high,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('fire'),
  enableLights: true,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessaging(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotoficationFirebase extends StatefulWidget {
  const NotoficationFirebase({Key? key}) : super(key: key);

  @override
  State<NotoficationFirebase> createState() => _NotoficationFirebaseState();
}

class _NotoficationFirebaseState extends State<NotoficationFirebase> {
  @override
  void initState() {
    super.initState();
    //объект для Android настроек
    const androidInitialize = AndroidInitializationSettings('ic_launcher');
    //объект для IOS настроек
    const iOSInitialize = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    // общая инициализация
    const initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    //мы создаем локальное уведомление
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channelFire.id, channelFire.name,
                    color: Colors.redAccent,
                    playSound: true,
                    sound: const RawResourceAndroidNotificationSound('fire'),
                    icon: '@drawable/heart',
                    largeIcon:
                        const DrawableResourceAndroidBitmap('@drawable/cat'),
                    enableLights: true)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
