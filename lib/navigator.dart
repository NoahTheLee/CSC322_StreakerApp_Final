import 'package:csc322_streaker_final/screens/credits_screen.dart';
import 'package:csc322_streaker_final/screens/home_screen.dart';
import 'package:csc322_streaker_final/screens/notifications_screen.dart';
import 'package:csc322_streaker_final/screens/profile_screen.dart';
import 'package:csc322_streaker_final/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 2; //Default to HomeScreen

  //Simple list to hold the screens themselves
  final List<Widget> _screens = [
    const CreditsScreen(),
    const ProfileScreen(),
    const HomeScreen(),
    const NotificationsScreen(),
    const SettingsScreen(),
  ];

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
              // IconButton for ProfileScreen
              icon: Image.asset(
                  // AssetImage('assets/icons/Profile_Icon.png'),
                  'assets/icons/Profile_Icon.png'
                  // color: Colors.red,
                  ),
              iconSize: 55,
              onPressed: () => _onItemTapped(1),
            ),
            IconButton(
              // IconButton for HomeScreen
              icon: Image.asset(
                // AssetImage('assets/icons/Home_Icon.png'),
                'assets/icons/Home_Icon.png',
                // color: Colors.red,
              ),
              iconSize: 900*55,
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              // IconButton for NotificationsScreen
              icon: Image.asset(
                // AssetImage('assets/icons/Notifications_Icon.png'),
                'assets/icons/Notifications_Icon.png',
                // color: Colors.red,
              ),
              iconSize: 55,
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              //   IconButton for SettingsScreen
              icon: Image.asset(
                // AssetImage('assets/icons/Settings_Icon.png'),
                'assets/icons/Settings_Icon.png',
                // color: Colors.red,
              ),
              iconSize: 55,
              onPressed: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}
