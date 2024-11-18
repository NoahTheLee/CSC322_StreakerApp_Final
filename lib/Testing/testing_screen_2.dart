import 'dart:convert';

import 'package:csc322_streaker_final/firebase%20stuff/firebase_handler.dart';
import 'package:csc322_streaker_final/models/handlers/user_setter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TestingScreen2 extends StatefulWidget {
  TestingScreen2({super.key});

  final String uid = '-OBwH73--ukahPMF4pX-';

  final Uri firebaseUrl = Uri.https(
      'csc322-streaker-final-default-rtdb.firebaseio.com', 'Test.json');

  @override
  _TestingScreen2State createState() => _TestingScreen2State();
}

class _TestingScreen2State extends State<TestingScreen2> {
  final TextEditingController taskName = TextEditingController();
  var task = '';

  @override
  dispose() {
    taskName.dispose();
    super.dispose();
  }

  void setValues() {
    task = taskName.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing Screen 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Text field for task name
            TextField(
              controller: taskName,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelText: 'Task Name',
              ),
            ),
            //Check data from Firebase
            TextButton(
              onPressed: () async {
                //TODO: Need loading method to fetch data

                //Function needs to await, since it returns a future
                await updateResponse();
                print('Raw data: $responseData');
                //Returns map of KVPs, which are themselves maps of KVPs
                print('Keys: $keys');
                print('Emails: $emails');
                print('Passwords: $passwords');
                print('Usernames: $usernames');
              },
              child: const Text('Retrieve data from Firebase'),
            ),
            //Reset basic user
            TextButton(
              child: const Text('Reset data'),
              onPressed: () async {
                //Testing with a different main header

                //Data sent with patch replaces or update given fields
                //If they exist, update. If they don't exist, set them

                //Data sent with PUT replaces the entire object
                final response = await http.put(
                  Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
                      'Users/${widget.uid}.json'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: json.encode(
                    //Content needs key-value pairs ('type': 'value')
                    {
                      'email': 'test@domain.net',
                      'password': "12345",
                      'username': "testuser",
                    },
                  ),
                );

                print(response.statusCode);

                //End of text button to-execute
              },
            ),
            //Send data to new field
            TextButton(
              child: const Text('Push other Data'),
              onPressed: () async {
                setValues();
                //By targeting the database, then a userID, then a specific subfolder, can push a segment of data
                http.patch(
                  Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
                      'Users/${widget.uid}/Data.json'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: json.encode({task: false}),
                );
                //End of text button to-execute
              },
            ),
            TextButton(
              onPressed: () {
                setUsers();
              },
              child: const Text('Check setting users'),
            ),
            TextButton(
              onPressed: () {
                findUser(widget.uid);
              },
              child: const Text('Check finding user'),
            ),
          ],
        ),
      ),
    );
  }
}
