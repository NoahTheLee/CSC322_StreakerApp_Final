import 'package:csc322_streaker_final/notifications.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Settings Screen',
            style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                NotificationService.showInstantNotification(
                  'instant notification', //TODO: Change the title
                  'This is an instant notification', //TODO: Change the body
                );
              },
              child: const SizedBox(
                width: 200,
                child: Text(
                  'Show Notification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                DateTime scheduledDate = DateTime.now().add(
                  const Duration(seconds: 5),
                ); //TODO: Change the scheduled date
                NotificationService.scheduleNotification(
                  'scheduled notification', //TODO: Change the title
                  'This notification is scheduled', //TODO: Change the body
                  scheduledDate,
                );
              },
              child: const SizedBox(
                width: 200,
                child: Text(
                  'Schedule Notification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
