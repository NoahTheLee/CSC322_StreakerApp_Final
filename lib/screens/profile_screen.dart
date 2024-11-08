import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _banner = 'assets/defaults/Default_Banner.png';
  final String _profile = 'assets/defaults/Default_Profile_Picture.png';
  final String _username = 'Username'; //Temporary Username

  final String _banner = 'assets/defaults/Default_Banner.png';
  final String _profile = 'assets/defaults/Default_Profile_Picture.png';
  final String _username = 'Username'; //Temporary Username

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            Stack(
              ///////////////////////////////Banner Picture Location///////////////////////////
              children: [
                const SizedBox(
                  height: 300,
                  width: double.infinity,
                ),
                Image.asset(
                  _banner,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                ////////////////////////////////////////////////////////////////////////////////
                /////////////////////////////Profile Picture Location///////////////////////////
                Positioned(
                  top: MediaQuery.sizeOf(context).height / 7,
                  left: MediaQuery.sizeOf(context).width / 2 - 64,
                  child: CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(_profile),
                    ),
                  ),
                ),
                ////////////////////////////////////////////////////////////////////////////////
                /////////////////////////////Username Location//////////////////////////////////
                Positioned(
                  bottom: 10,
                  left: MediaQuery.sizeOf(context).width / 2 -
                      _username.length * 9,
                  child: Text(
                    _username, //Temporary Username
                    style: const TextStyle(
                      color: Color.fromARGB(255, 221, 218, 255),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                ////////////////////////////////////////////////////////////////////////////////
              ],
            ),
            //////////////////////////////Items to Track Title//////////////////////////////////
            const SizedBox(height: 20),
            const Text(
              'Your Items to Track',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial Black',
              ),
            ),
            ////////////////////////////////////////////////////////////////////////////////////
            //////////////////////////////Items to Track List///////////////////////////////////
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 2 - 100,
              width: MediaQuery.sizeOf(context).width - 20,
              child: const SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Text(
                      'Item 1',
                      style: TextStyle(
                        color: Color.fromARGB(255, 196, 196, 196),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ////////////////////////////////////////////////////////////////////////////////////
            //////////////////////////////Add New Item//////////////////////////////////////////
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Enter your new item here',
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 166, 166, 166),
                  fontSize: 15,
                ),
              ),
            ),
            /////////////////////////////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}
