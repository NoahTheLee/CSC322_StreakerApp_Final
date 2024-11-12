import 'package:csc322_streaker_final/Testing/testing_screen.dart';
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

  bool testingEnabled = false; //TODO: Remove this when testing is complete

  doLogin() {
    setState(() {
      isLoggedIn = true;
    });
  }

  var uid = '';

  updUid(String newUid) {
    setState(() {
      uid = newUid;
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
      home: testingEnabled
          ? const TestingScreen() //TODO: Remove this when testing is complete
          : isLoggedIn
              ? HomePage(uid: uid)
              : LoginPage(doLogin: doLogin, changeUid: updUid),
    );
  }
}
