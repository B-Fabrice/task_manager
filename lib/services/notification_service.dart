// import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/notification.dart';

class NotificationService {
  static final fireMessage = FirebaseMessaging.instance;
  static final firestore = FirebaseFirestore.instance;
  static final collection = collections.notifications;
  // static final notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await fireMessage.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage((message) {
      return fireMessageBackgroundHandler(message);
    });

    // InitializationSettings initializationSettings = InitializationSettings(
    //   android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
    //   iOS: DarwinInitializationSettings(
    //     requestSoundPermission: true,
    //     requestBadgePermission: true,
    //     requestAlertPermission: true,
    //   ),
    // );

    // notificationsPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse:
    //       (NotificationResponse notificationResponse) {},
    // );
  }

  static Future<void> fireMessageBackgroundHandler(
    RemoteMessage message,
  ) async {
    showNotification(message);
  }

  static Future<void> sendNotification(Map<String, dynamic> data) async {
    await firestore.collection(collection).add(data);
  }

  static Future<void> readNotifications(List<String> ids) async {
    for (int i = 0; i < ids.length; i += 20) {
      final lastIndex = i + 20 > ids.length ? ids.length : i + 20;
      final data = ids.sublist(i, lastIndex);
      final batch = firestore.batch();
      for (final id in data) {
        batch.update(firestore.collection(collection).doc(id), {
          'isRead': true,
        });
      }
      await batch.commit();
    }
  }

  static Future<void> deleteAllNotifications(List<UserNotification> ids) async {
    for (int i = 0; i < ids.length; i += 20) {
      final lastIndex = i + 20 > ids.length ? ids.length : i + 20;
      final data = ids.sublist(i, lastIndex);
      final batch = firestore.batch();
      for (final id in data) {
        batch.delete(firestore.collection(collection).doc(id.id));
      }
      await batch.commit();
    }
  }

  static final userNotificationStream = StreamProvider<List<UserNotification>>((
    ref,
  ) {
    final auth = FirebaseAuth.instance;
    final userId = auth.currentUser?.uid;
    return firestore
        .collection(collection)
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((e) {
            return UserNotification.fromJson(e.data(), e.id);
          }).toList();
        });
  });

  static showNotification(RemoteMessage notification) async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      // try {
      //   final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      //   const NotificationDetails notificationDetails = NotificationDetails(
      //     android: AndroidNotificationDetails(
      //       'default_channel_id',
      //       'Default Channel',
      //       channelDescription: 'This is the default channel',
      //       importance: Importance.max,
      //       priority: Priority.high,
      //       ticker: 'ticker',
      //       playSound: true,
      //       enableLights: true,
      //       enableVibration: true,
      //       visibility: NotificationVisibility.public,
      //     ),
      //     iOS: DarwinNotificationDetails(
      //       sound: 'default',
      //       presentSound: true,
      //       presentAlert: true,
      //       presentBadge: true,
      //     ),
      //   );

      //   await notificationsPlugin.show(
      //     id,
      //     notification.notification?.title,
      //     notification.notification?.body,
      //     notificationDetails,
      //     payload: jsonEncode(notification.data),
      //   );
      // } on Exception catch (_) {}
    }
  }

  static Future<void> setToken(String id) async {
    try {
      await fireMessage.getToken();
    } catch (e) {
      print(e);
    }
  }
}
