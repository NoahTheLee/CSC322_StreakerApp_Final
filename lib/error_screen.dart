import 'package:csc322_streaker_final/globals.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    enterErrorState();
    print('Error state triggered');
    final String errorMessage =
        ModalRoute.of(context)!.settings.arguments as String;

// Split the string
    List<String> parts = errorMessage.split('||| Source:');
// Trim whitespace from each part
    String reason = parts[0].trim();
    String source = parts.length > 1 ? parts[1].trim() : '';

// Use the parsed values
    print('Reason was: $reason');
    print('Source is: $source');

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Oops! Something went wrong.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Text(
                reason,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                source,
                style: const TextStyle(
                  color: Color.fromARGB(255, 128, 128, 128),
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  exitErrorState();
                  Navigator.of(context).pop();
                },
                child: const Text('Go Back'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('avoid state reset')),
            ],
          ),
        ),
      ),
    );
  }
}
