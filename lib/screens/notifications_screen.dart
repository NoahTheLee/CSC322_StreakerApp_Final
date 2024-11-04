import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Screen'),
      ),
      body: const Center(
        child: Text(
          'This is the content of the screen.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
