import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
//Required import for http

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  //Handling text input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  //Empty lists to store data from Firebase
  final List<String> keys = [];
  final List<String> emails = [];
  final List<String> passwords = [];
  final List<String> usernames = [];
  //fullResponse initialized as empty, but will store raw data from Firebase
  late http.Response fullResponse;
  //responseData initialized as empty, will store decoded data from Firebase
  late Map<String, dynamic> responseData = {};
  //NOTE: The inner map will PROBABLY stay as Dynamic since this might also store images???

  //Empty strings to store data
  var email = '';
  var password = '';
  var username = '';

  //Firebase URL
  //Formatted as Uri.https('link', 'path.json')
  final Uri firebaseUrl = Uri.https(
      'csc322-streaker-final-default-rtdb.firebaseio.com', 'Users.json');

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

  //Function to update response
  //This needs to be future, since it's an async function... Neat
  Future<void> updateResponse() async {
    //Pulling data with GET
    //Formatted as http.get(url)
    fullResponse = await http.get(firebaseUrl); //pulls data from Firebase
    //fullResponse should NEVER be used for anything at all ever since it's "junk" data

    responseData = json
        .decode(fullResponse.body); //Converts data into a KVP of KVPs (bruh)

    for (final item in responseData.entries) {
      keys.add(item.key);
      emails.add(item.value['email']);
      passwords.add(item.value['password']);
      usernames.add(item.value['username']);
    }
  }

  //Super simple function to return a boolean if login is successful
  Future<bool> checkLogin(String email, String password) async {
    await updateResponse();

    //Even if not null, might not be in database

    if (!(email.isEmpty || password.isEmpty || !emails.contains(email)) &&
        passwords[emails.indexOf(email)] == password) {
      print('Yay you can log in');
      return true;
    } else {
      print('Nope, you can\'t log in');
      return false;
    }
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

                print(response.statusCode);
                //100-199 are informational (not used?) and 300-399 are redirection (also not used?)
                //Values between 200 and 299 are successful
                //Values between 400 and 499 are client errors
                //Values between 500 and 599 are server errors

                print(json.decode(response.body)['name']);
                //Returns "name": "-key" if successful as well
                //TODO: Store this permanently per-instance?
              },
              child: const Text('Send data to Firebase'),
            ),
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
            TextButton(
              onPressed: () async {
                setValues();

                print('Email: $email');
                print('Password: $password');

                print(await checkLogin(email, password)
                    ? 'Login successful'
                    : 'Login failed');
              },
              child: const Text('Check Data'),
            ),
          ],
        ),
      ),
    );
  }
}
