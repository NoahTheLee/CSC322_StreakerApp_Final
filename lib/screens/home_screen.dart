import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.uid});

  final String uid;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool checkedValue = false;
  bool checkedValue2 = false;

  Color _colorButton() {
    if(checkedValue && checkedValue2) {
      return const Color.fromARGB(255, 211, 47, 47);
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
        leading: IconButton(
          // icon: const Icon(Icons.adb),
          icon: Image.asset('assets/icons/Chatbot_Icon.png'),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
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
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.only(left: 100, right: 100),
              checkColor: Colors.white,
              value: checkedValue,
              onChanged: (newValue) {
                setState(() {
                  checkedValue = newValue!;
                });
              },
              title: const Text(
                'Task 1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.only(left: 100, right: 100),
              checkColor: Colors.white,
              value: checkedValue2,
              onChanged: (newValue) {
                setState(() {
                  checkedValue2 = newValue!;
                });
              },
              title: const Text(
                'Task But It Is A Really Long Task Name so that I can test how It reacts to a long task name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20 - 5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
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
            ElevatedButton(
                onPressed: () {
                  print(widget.uid);
                },
                child: const Text('Print UID'))
          ],
        ),
      ),
    );
  }
}
