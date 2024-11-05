import 'package:csc322_streaker_final/screens/credits_screen.dart';
import 'package:csc322_streaker_final/screens/home_screen.dart';
import 'package:csc322_streaker_final/screens/notifications_screen.dart';
import 'package:csc322_streaker_final/screens/profile_screen.dart';
import 'package:csc322_streaker_final/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.analytics),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => _onItemTapped(1),
            ),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}
