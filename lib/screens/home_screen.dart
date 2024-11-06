import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        leading: IconButton(
          icon: Image.asset('assets/icons/Chatbot_Icon.png'),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
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
