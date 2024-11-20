import 'package:flutter/material.dart';
import '/api/ai_image_api.py';

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({super.key});

  @override
  _CompleteScreenState createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              child: const Text('Continue'),
            )
          ],
        ),
      ),
    );
  }
}

//  const Text(
            //   'Congratulations! You have completed the game!',
            //   style: TextStyle(
            //     fontSize: 20,
            //     color: Colors.white,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 20),
            // const Text(
            //   'Watch the rocket fly!',
            //   style: TextStyle(
            //     fontSize: 15,
            //     color: Colors.white,
            //   ),
            // ),