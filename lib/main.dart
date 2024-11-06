import 'package:csc322_streaker_final/screens/login pages/login_page.dart';
import 'package:flutter/material.dart';

import 'package:csc322_streaker_final/navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  doLogin() {
    setState(() {
      isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? const HomePage() : LoginPage(doLogin: doLogin),
    );
  }
}
