import 'package:csc322_streaker_final/Testing/testing_screen.dart';
import 'package:csc322_streaker_final/Testing/testing_screen_2.dart';
import 'package:csc322_streaker_final/models/handlers/user_setter.dart';
import 'package:csc322_streaker_final/screens/login pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:csc322_streaker_final/navigator.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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

  int testState = 0; //TODO: Remove this when testing is complete
  // 1 = TestingScreen 2 = TestingScreen2
  bool testingEnabled = false; //TODO: Remove this when testing is complete
  bool testingEnabled2 = false; //TODO: Remove this when testing is complete

  var uid = '';

  doLogin() async {
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
    if (testState == 1) {
      testingEnabled = true;
    } else if (testState == 2) {
      testingEnabled = true;
      testingEnabled2 = true;
    }

    return testingEnabled
        ? testingEnabled2
            ? TestingScreen2() //TODO: Remove this when testing is complete
            : const TestingScreen() //TODO: Remove this when testing is complete
        : isLoggedIn
            ? HomePage(uid: uid)
            : LoginPage(doLogin: doLogin, changeUid: updUid);
  }
}
