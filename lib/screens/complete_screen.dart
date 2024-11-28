import 'dart:io';
import 'dart:math';

import 'package:csc322_streaker_final/api/ai_image_api.dart';
import 'package:flutter/material.dart';
// import 'ai_image_api.dart'; // Import the ai_image_api.dart file

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({super.key});

  @override
  CompleteScreenState createState() => CompleteScreenState();
}

class CompleteScreenState extends State<CompleteScreen> {
  bool _isLoading = true;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  int getRandomSeed(Random rand) {
    var randVal = int.parse(rand.nextDouble().toString().substring(2)) +
        int.parse(
            ((DateTime.now().toString()).replaceAll(RegExp(r'[^0-9]'), ''))
                .substring(8));
    randVal = randVal % 100000;
    return randVal;
  }

  Future<void> _loadImage() async {
    const prompt = 'Generate_an_image_of_a_futuristic_rocket_ship_blasting_off';
    const width = 360;
    const height = 800;
    const model = 'flux';

    final random = Random();
    final seed = getRandomSeed(random);

    final imageUrl = generateImageUrl(
      prompt: prompt,
      width: width,
      height: height,
      seed: seed,
      model: model,
    );

    final imagePath = await downloadImage(imageUrl);

    setState(() {
      _imagePath = imagePath;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    if (_imagePath != null)
                      Image.file(
                        File(_imagePath!),
                        fit: BoxFit.cover,
                      )
                    else
                      const Text('Error loading image'),
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
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
