import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oxdo_message/main.dart';
import 'package:oxdo_message/opened_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _showNotification(
      {required String notificationTitle,
      required String notificationBody}) async {
    // Required for android
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // show notification
    await flutterLocalNotificationsPlugin.show(
      0, // notification id
      notificationTitle,
      notificationBody,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }

  @override
  void initState() {
    // To Receive message in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      print("onMessage Title:- ${remoteMessage.notification?.title}");
      print("onMessage Body:- ${remoteMessage.notification?.body}");

      _showNotification(
        notificationTitle: "${remoteMessage.notification?.title}",
        notificationBody: "${remoteMessage.notification?.body}",
      );


    });


    // if app is in background and recieved notification, it will trigger when we press notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      print(" onMessageOpenedApp Title:- ${remoteMessage.notification?.title}");
      print("onMessageOpenedApp Body:- ${remoteMessage.notification?.body}");
      
       // navigate to opend screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  OpenedScreen(remoteMessage: remoteMessage)));
        });
    });

    // if app is in terminated and recieved notification, it will trigger when we press notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        print(
            " getInitialMessage Title:- ${remoteMessage.notification?.title}");
        print("getInitialMessage Body:- ${remoteMessage.notification?.body}");

        // navigate to opened screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  OpenedScreen(remoteMessage: remoteMessage)));
        });
      } else {
        print("getInitialMessage Remote message is null");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home screen"),
      ),
      body: const Center(
        child: Text("Home"),
      ),
    );
  }
}
