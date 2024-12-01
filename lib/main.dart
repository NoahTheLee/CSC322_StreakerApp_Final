import 'package:csc322_streaker_final/screens/complete_screen.dart';
import 'package:csc322_streaker_final/error_screen.dart';
import 'package:csc322_streaker_final/screens/login pages/login_page.dart';
import 'package:flutter/material.dart';

import 'package:csc322_streaker_final/navigator.dart';

void main() {
  runApp(
    const MyApp(),
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
        '/error': (context) => const ErrorScreen(),
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

  bool hasErrored = false;

  var uid = '';

  doLogin() async {
    setState(() {
      isLoggedIn = true;
    });
  }

  void errorOccured() {
    setState(() {
      hasErrored = true;
    });
  }

  updUid(String newUid) {
    setState(() {
      uid = newUid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? HomePage(uid: uid)
        : LoginPage(doLogin: doLogin, changeUid: updUid);
  }
}
