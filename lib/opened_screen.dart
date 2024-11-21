import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class OpenedScreen extends StatelessWidget {
  final RemoteMessage remoteMessage;
  const OpenedScreen({super.key, required this.remoteMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Opened app"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(remoteMessage.notification?.title ?? "No message"),
            const SizedBox(
              height: 16,
            ),
            Text("Body:- ${remoteMessage.notification?.body}"),
          ],
        ),
      ),
    );
  }
}
