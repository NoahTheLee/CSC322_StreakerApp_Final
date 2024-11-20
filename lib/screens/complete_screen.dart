import 'dart:convert';

// import 'package:csc322_streaker_final/api/ai_image_api.py';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({super.key});

  @override
  CompleteScreenState createState() => CompleteScreenState();
}

class CompleteScreenState extends State<CompleteScreen> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.of(context).size.width;
    final double imageHeight = MediaQuery.of(context).size.height;
    final imageUrl = Uri.https(
        'pollinations.ai', 
        '/p/Generate_an_image_of_a_futuristic_rocket_ship_blasting_off', 
        {
          'width': '$imageWidth',
          'height': '$imageHeight',
          'seed': '702115403',
          'model': 'flux'
        }).toString();
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          imageUrl,
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              setState(() {
                                _isLoading = false;
                              });
                              return child;
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Error loading image');
                          },
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
