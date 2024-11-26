import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:csc322_streaker_final/firebase%20stuff/firebase_handler.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.uid});

  final String uid;

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool checkedValue = false;
  bool _dailyStreak = false;
  dynamic streakCounter = 'Loading...';

  Map<String, bool> taskMap = {
    'Loading...': false,
  };

  @override
  initState() {
    startTimer();
    getTaskMap();
    setStreakCount();
    super.initState();
  }

  void setStreakCount() {
    getStreak(widget.uid).then((value) {
      setState(() {
        streakCounter = value;
      });
    });
  }

  void startTimer() {
    //TODO: make this just happen from navigator
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      getTaskMap();
    });
  }

  void getTaskMap() async {
    await getTasks(widget.uid).then((value) {
      setState(() {
        taskMap = value;
      });
    });
  }

  Color _colorButton() {
    if (!taskMap.containsValue(false)) {
      return const Color.fromARGB(255, 211, 47, 47);
    } else {
      return Colors.grey;
    }
  }

  Color _colorStreak() {
    if (_dailyStreak) {
      return const Color.fromARGB(255, 234, 102, 21);
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 0, 0, 65), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Leading section: Icon and counter
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: _colorStreak(), // Custom color function
                          size: 28,
                        ),
                        const SizedBox(
                            width: 4), // Spacing between icon and number
                        Text(
                          streakCounter
                              .toString(), // Replace with your dynamic value
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/titles/Logo.png',
                    height: 300,
                    width: 300,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    child: Image.asset('assets/titles/Title.png'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: taskMap.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding:
                        const EdgeInsets.only(left: 100, right: 100),
                    checkColor: Colors.white,
                    title: AutoSizeText(
                      taskMap.keys.elementAt(index),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      minFontSize: 10,
                      maxFontSize: 20,
                      softWrap: true,
                      maxLines: 4,
                    ),
                    value: taskMap.values.elementAt(index),
                    onChanged: (bool? value) {
                      updateTask(widget.uid, taskMap.keys.elementAt(index));
                      setState(() {
                        print('Selected Index: $index');
                        taskMap[taskMap.keys.elementAt(index)] = value!;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!taskMap.containsValue(false)) {
                  //handle comparisons

                  //Check stored date against current date
                  if (!await compareDates(widget.uid)) {
                    await incStreak(widget.uid);
                    setState(() {
                      setStreakCount();
                    });
                  } else {
                    print('Streak has been reset');
                    await resetStreak(widget.uid);
                    setState(() {
                      setStreakCount();
                    });
                  }

                  //TODO: Temporarily disable screen pushing
                  // Navigator.pushNamed(context, '/complete');
                  setState(() {
                    _dailyStreak = true;
                  });
                  //This can be called after the setState, since all it does is update the streak on Firebase
                  sendDate(widget.uid);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _colorButton(),
                foregroundColor: const Color.fromARGB(255, 43, 30, 30),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Complete Tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
