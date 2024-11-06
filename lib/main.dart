import 'package:flutter/material.dart';

import 'package:csc322_streaker_final/navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        // appBarTheme: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
