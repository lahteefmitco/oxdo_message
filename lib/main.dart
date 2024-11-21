import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oxdo_message/firebase_options.dart';
import 'package:oxdo_message/home_screen.dart';

@pragma('vm:entry-point')
Future _backgroundMessageHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance.subscribeToTopic("topic");

  print(
      "backgroundMessageHandler Title:- ${remoteMessage.notification?.title}");
  print("backgroundMessageHandler Body:- ${remoteMessage.notification?.body}");
}

// late initialize FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // FCM required notification permission
  final NotificationSettings notificationSettings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    criticalAlert: true,
    provisional: true,
    announcement: true,
  );

  // If the platform is Android, it will display the permission status.
  print(notificationSettings.authorizationStatus.name);
  // If the user grants permission, it will print 'authorized'; otherwise, it will print 'denied'.

  // To send message to specific device
  final firebaseMessagingToken = await FirebaseMessaging.instance.getToken();

  log("Token $firebaseMessagingToken", name: "oxdo");

  // To subscribe a topic
  await FirebaseMessaging.instance.subscribeToTopic("sample_topic");

  // To handle background messages
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  await _initializeNotification();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

// Initialize the notification settings for Android and iOS
Future _initializeNotification() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      // Handle notification tapped logic here
    },
  );
}
