import 'package:csc322_streaker_final/screens/credits_screen.dart';
import 'package:csc322_streaker_final/screens/home_screen.dart';
import 'package:csc322_streaker_final/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.uid,
  });

  final String uid;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 2; //Default to HomeScreen

  //Simple list to hold the screens themselves
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const CreditsScreen(),
      ProfileScreen(uid: widget.uid),
      HomeScreen(uid: widget.uid),
    ];
  }

  //Function to change the selected index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Main "body" itself, uses IndexedStack to toggle between screens
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // BottomAppBar with navigation buttons
      bottomNavigationBar: BottomAppBar(
        color: Colors.black87,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              // IconButton for CreditsScreen
              icon: Image.asset(
                // AssetImage('assets/icons/Acknowledgements_Icon.png'),
                'assets/icons/Acknowledgements_Icon.png',
                // color: Colors.red,
              ),
              iconSize: 55,
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              // IconButton for HomeScreen
              icon: Image.asset(
                // AssetImage('assets/icons/Home_Icon.png'),
                'assets/icons/Home_Icon.png',
                // color: Colors.red,
              ),
              iconSize: 900 * 55,
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              // IconButton for ProfileScreen
              icon: Image.asset(
                  // AssetImage('assets/icons/Profile_Icon.png'),
                  'assets/icons/Profile_Icon.png'
                  // color: Colors.red,
                  ),
              iconSize: 55,
              onPressed: () => _onItemTapped(1),
            ),
          ],
        ),
      ),
    );
  }
}
