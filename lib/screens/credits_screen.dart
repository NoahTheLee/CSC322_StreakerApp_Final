import 'package:flutter/material.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  @override
  CreditsScreenState createState() => CreditsScreenState();
}

class CreditsScreenState extends State<CreditsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:
            const Text('Credits Screen', style: TextStyle(color: Colors.white)),
      ),
      body: const SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This app was created by the CSC322 Streaker Team\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '> Diego Patterson - Programmer <\n\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            Text(
              '> Noah Lee - Programmer <\n\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            Text(
              '> Professor Grissom - The Teacher <\n\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              '> ❤️ Copilot - My Beloved ❤️ <\n\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 255, 146, 228),
              ),
            ),
            Text(
              '> Lofi Hiphop Beats to Chill And Study To - Lifeline <\n\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 0, 238, 255),
              ),
            ),
            Text(
              '> StackOverflow - The Savior <\n\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 243, 109, 109),
              ),
            ),
            Text(
              '> Google - The Search Engine <\n\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 150, 255, 150),
              ),
            ),
            Text(
              '> Rockstar - Diegos Choice <\n\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 247, 255, 129),
              ),
            ),
            Text(
              '> Monster - Noahs Choice <\n\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 150, 255, 129),
              ),
            ),
            Text(
              '> Many Sleepless nights - Routine <\n\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 129, 255, 255),
              ),
            ),
            Text(
              '> And Users Like You <',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              '> Thank You so much for using our app and I hope it < \n > helps you with all the Goals you can dream up <\n\n',
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
