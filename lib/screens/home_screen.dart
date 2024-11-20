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


  Map<String, bool> taskMap = {
    'Loading': false,
    'Loading.': false,
    'Loading..': false,
    'Loading...': false,
  };

  @override
  initState() {
    startTimer();
    getTaskMap();
    super.initState();
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 65),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        title: const Text('Home Screen'),
        // leading: IconButton(
        //   // icon: const Icon(Icons.adb),
        //   icon: Image.asset('assets/icons/Chatbot_Icon.png'),
        //   onPressed: () {
        //     _scaffoldKey.currentState!.openDrawer();
        //   },
        // ),
        leading: IconButton(
          icon: Icon(
            Icons.local_fire_department,
            color: _colorStreak(),
          ),
          onPressed: () {},
        ),
      ),
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
              onPressed: () {
                if (!selectedItems.contains(false)) {
                  Navigator.pushNamed(context, '/complete');
                  setState(() {
                    _dailyStreak = true;
                  });
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
