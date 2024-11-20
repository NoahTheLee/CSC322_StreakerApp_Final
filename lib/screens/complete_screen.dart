import 'package:csc322_streaker_final/api/ai_image_api.py';
import 'package:flutter/material.dart';


class CompleteScreen extends StatefulWidget {
  const CompleteScreen({super.key});

  @override
  CompleteScreenState createState() => CompleteScreenState();
}

class CompleteScreenState extends State<CompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [
                download_image(image_url) == null
                    ? const CircularProgressIndicator()
                    : Image.network(
                        download_image(image_url),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                Positioned(
                  bottom: 10,
                  child: ElevatedButton(
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
                  ),
                )
              ],
            ),
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
