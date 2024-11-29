// ignore_for_file: avoid_print

import 'package:csc322_streaker_final/firebase/firebase_handler.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
//Required import for http

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  final String uid = '-OBEdvzL_pyEWsEPQP_w';

  @override
  TestingScreenState createState() => TestingScreenState();
}

class TestingScreenState extends State<TestingScreen> {
  //Handling text input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  //Empty strings to store data
  var email = '';
  var password = '';
  var username = '';

  @override
  void dispose() {
    //Get rid of controllers and nodes when they're not used any more
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void setValues() {
    //Update values of email, password, and username
    email = emailController.text;
    password = passwordController.text;
    username = usernameController.text;
  }

  void getuid() {
    print(keys[emails.indexOf(email)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              style: const TextStyle(color: Colors.white),
            ),
            TextButton(
              onPressed: () async {
                setValues();

                //Sending data with POST
                //Formatted as http.post(url, headers: {'content-type': 'application/json'})
                //Also returns a response IF async is used in the header of the function AND response = await (VERY IMPORTANT)
                final response = await http.post(
                  firebaseUrl,
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: json.encode(
                    //Content needs key-value pairs ('type': 'value')
                    {
                      'email': email,
                      'password': password,
                      'username': username,
                    },
                  ),
                );

                print('TEXT response code: ${response.statusCode}');
                //100-199 are informational (not used?) and 300-399 are redirection (also not used?)
                //Values between 200 and 299 are successful
                //Values between 400 and 499 are client errors
                //Values between 500 and 599 are server errors

                print(json.decode(response.body)['name']);
                //Returns "name": "-key" if successful as well
              },
              child: const Text('Send data to Firebase'),
            ),
            //Get data from Firebase
            TextButton(
              onPressed: () async {
                //Function needs to await, since it returns a future
                await updateResponse(context);
                print('Raw data: $responseData');
                //Returns map of KVPs, which are themselves maps of KVPs
                print('Keys: $keys');
                print('Emails: $emails');
                print('Passwords: $passwords');
                print('Usernames: $usernames');
              },
              child: const Text('Retrieve data from Firebase'),
            ),
            //Test login against data
            TextButton(
              onPressed: () async {
                setValues();
                getuid();
              },
              child: const Text('Check Data'),
            ),
            TextButton(
                onPressed: () async {
                  await updateResponse(context);
                },
                child: const Text('Print Data')),
          ],
        ),
      ),
    );
  }
}
