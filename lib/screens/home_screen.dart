import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            // AssetImage('assets/icons/Acknowledgements_Icon.png'),
            'assets/icons/Chatbot_Icon.png',
            // color: Colors.red,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.speaker)
              //IconButton( //Alternate icon for using a custom image
              // icon: Image.asset(
              //   'assets/images/icon_image.png',
              //   width: 24,
              //   height: 24,
              // ),
              ),
        ],
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text(
          'This is the content of the screen.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
