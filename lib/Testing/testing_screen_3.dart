// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:csc322_streaker_final/firebase/firebase_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TestingScreen3 extends StatefulWidget {
  const TestingScreen3({super.key});

  final String uid = '-OBwH73--ukahPMF4pX-';

  @override
  TestingScreen3State createState() => TestingScreen3State();
}

//Used only once to send a streak counter
void tempSend(String uid) async {
  http.patch(
    Uri.https(
        'csc322-streaker-final-default-rtdb.firebaseio.com', 'Users/$uid.json'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({'Streak': 0}),
  );
}

class TestingScreen3State extends State<TestingScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Screen 3'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Streak Handling
            ExpansionTile(
              title: const Text(
                'Streak Handling',
                style: TextStyle(color: Colors.white),
              ),
              children: <Widget>[
                ListTile(
                  title: const Text(
                    'Force streak counter onto uid',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    tempSend(widget.uid);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Increment streak counter',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    incStreak(widget.uid);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Reset streak counter',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    resetStreak(widget.uid);
                  },
                ),
              ],
            ),
            //Date handling
            ExpansionTile(
              title: const Text(
                'Date Handling',
                style: TextStyle(color: Colors.white),
              ),
              children: <Widget>[
                ListTile(
                  title: const Text(
                    'Get current date',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print(DateTime.now());
                  },
                ),
                ListTile(
                  title: const Text(
                    'Send current date to uid',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    sendDate(widget.uid);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Get date from uid',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await getDate(widget.uid).then((value) => print(value));
                  },
                ),
                ListTile(
                  title: const Text(
                    'Compare dates',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    print(await compareDates(widget.uid)
                        ? 'Is over 24 hours of difference'
                        : 'Is not over 24 hours of difference');
                  },
                ),
              ],
            ),
            //Empty Expansion Tile
            ExpansionTile(
              title: const Text(
                'Miscellaneous',
                style: TextStyle(color: Colors.white),
              ),
              children: <Widget>[
                ListTile(
                  title: const Text(
                    'Strip numbers from string',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    'Reset Tasks',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    resetTasks(widget.uid);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
