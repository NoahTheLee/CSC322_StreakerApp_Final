import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Notifications Screen',
            style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text(
          'This is the content of the screen.',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
