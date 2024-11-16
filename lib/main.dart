import 'package:csc322_streaker_final/Testing/testing_screen.dart';
import 'package:csc322_streaker_final/screens/login pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:csc322_streaker_final/navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      // Wrap your entire app in ProviderScope
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          primarySwatch: Colors.blue,
        ),
        home: const MyHome(), // Home page remains as is
      ),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool isLoggedIn = false;
  bool testingEnabled = false; //TODO: Remove this when testing is complete
  var uid = '';

  doLogin() {
    setState(() {
      isLoggedIn = true;
    });
  }

  updUid(String newUid) {
    setState(() {
      uid = newUid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return testingEnabled
        ? const TestingScreen() //TODO: Remove this when testing is complete
        : isLoggedIn
            ? HomePage(uid: uid)
            : LoginPage(doLogin: doLogin, changeUid: updUid);
  }
}
