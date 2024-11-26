import 'package:csc322_streaker_final/Testing/testing_screen.dart';
import 'package:csc322_streaker_final/Testing/testing_screen_2.dart';
import 'package:csc322_streaker_final/Testing/testing_screen_3.dart';
import 'package:csc322_streaker_final/screens/complete_screen.dart';
import 'package:csc322_streaker_final/screens/login pages/login_page.dart';
import 'package:flutter/material.dart';

import 'package:csc322_streaker_final/navigator.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/complete': (context) => const CompleteScreen(),
        // '/home': (context) => const HomeScreen(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: const MyHome(), // Home page remains as is
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
  // 1 = TestingScreen 2 = TestingScreen2 3 = TestingScreen3

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
    switch (testState) {
      case 0:
        return isLoggedIn
            ? HomePage(uid: uid)
            : LoginPage(doLogin: doLogin, changeUid: updUid);
      case 1:
        return TestingScreen();
      case 2:
        return TestingScreen2();
      case 3:
        return TestingScreen3(); //TODO: Remove this when testing is complete
    }

    return const Center(
      child: Text('uh oh\nsomething went wrong'),
    );
  }
}
