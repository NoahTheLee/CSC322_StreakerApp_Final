import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Profile Screen', style: TextStyle(color: Colors.white)),
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
