import 'package:flutter/material.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  @override
  CreditsScreenState createState() => CreditsScreenState();
}

class CreditsScreenState extends State<CreditsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:
            const Text('Credits Screen', style: TextStyle(color: Colors.white)),
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
