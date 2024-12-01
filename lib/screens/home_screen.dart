import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:csc322_streaker_final/firebase/firebase_handler.dart';
import 'package:csc322_streaker_final/globals.dart';
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

  String timerText = 'Loading...';

  Map<String, bool> taskMap = {
    'Loading...': false,
  };

  bool mapEmpty = false;

  @override
  initState() {
    startTimer();
    getTaskMap();
    setStreakCount();
    checkEmpty();
    updateTimer();
    super.initState();
  }

  void setStreakCount() {
    getStreak(uid: widget.uid, context: context).then((value) {
      setState(() {
        streakCounter = value;
      });
    });
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (!errState) {
        getTaskMap();
        updateTimer();
        checkEmpty();
      }
    });
  }

  void checkEmpty() {
    if (taskMap.isEmpty) {
      setState(() {
        mapEmpty = true;
      });
    } else {
      setState(() {
        mapEmpty = false;
      });
    }
  }

  void updateTimer() async {
    timeUntil24Hours(uid: widget.uid, context: context).then((value) {
      setState(() {
        timerText = value;
      });
    });
  }

  void getTaskMap() async {
    await getTasks(uid: widget.uid, context: context).then((value) {
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
                    Icon(
                      Icons.local_fire_department,
                      color: _colorStreak(), // Custom color function
                      size: 28,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      streakCounter.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text('Time until streak reset: $timerText',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
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
              child: mapEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          color: Colors.white,
                          size: 50,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Add tasks to get started!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
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
                            updateTask(
                                uid: widget.uid,
                                task: taskMap.keys.elementAt(index),
                                context: context);
                            setState(() {
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
                  if (!await compareDates(uid: widget.uid, context: context)) {
                    await incStreak(uid: widget.uid, context: context);
                    setState(() {
                      setStreakCount();
                    });
                  } else {
                    await resetStreak(uid: widget.uid, context: context);
                    setState(() {
                      setStreakCount();
                    });
                  }

                  Navigator.pushNamed(context, '/complete');
                  setState(() {
                    _dailyStreak = true;
                  });
                  //This can be called after the setState, since all it does is update the streak on Firebase
                  sendDate(uid: widget.uid, context: context);
                  resetTasks(uid: widget.uid, context: context);
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
