import 'dart:convert';

import 'package:csc322_streaker_final/screens/login%20pages/sign_in.dart';
import 'package:csc322_streaker_final/screens/login%20pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.doLogin});

  final void Function() doLogin;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //Color of menu, easy to change for theming
  final Color menuStyle = Colors.white;
  //Controllers for getting email and password data
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordMatchingController =
      TextEditingController();

  //empty variables for email and password
  bool _signUp = false;

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
  var checkPassword = '';
  var password = '';
  var username = '';

  //Firebase URL
  //Formatted as Uri.https('link', 'path.json')
  final Uri firebaseUrl = Uri.https(
      'csc322-streaker-final-default-rtdb.firebaseio.com', 'Users.json');

  @override
  void initState() {
    super.initState();
  }

  void setValues() {
    //Update values of email, password, and username
    email = _emailController.text;
    password = _passwordController.text;
    checkPassword = _passwordMatchingController.text;
    username = _usernameController.text;
  }

  Future<bool> checkLogin(String email, String password) async {
    await updateResponse();

    //Check if email and password are in the lists, then check if password is correct
    if (!(email.isEmpty || password.isEmpty || !emails.contains(email)) &&
        passwords[emails.indexOf(email)] == password) {
      print('Yay you can log in'); //TODO: remove this
      return true;
    } else {
      print('Nope, you can\'t log in'); //TODO: remove this
      signingDataError('Incorrect email or password.');
      return false;
    }
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

  void signUserIn() async {
    //Empty placeholder to print values to the debug console.
    //Later, this should check firebase for login status
    setValues();

    if (await checkLogin(email, password)) {
      widget
          .doLogin(); //Moves to app home page, should only be called if login is successful
    }
  }

  Future signingDataError(String errMessage) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Incorrect Data...'),
          content: Text(errMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _createUser() async {
    await updateResponse();
    //TODO: Handle backend response if no response is received
    setValues();
    //Testing data for now

    print(
        'Username: $username, Email: $email, Password: $password, Checked password: $checkPassword'); //TODO: remove this

    //TODO: decide if I want to display any kind of error on each field if it's incorrect
    if (username.isEmpty) {
      print('handle empty username'); //TODO: handle empty username
      signingDataError('Username is required.');
      return;
    }
    if (usernames.contains(username)) {
      print('handle duplicate username'); //TODO: handle duplicate username
      signingDataError('Username is already in use.');
      return;
    }
    if (email.isEmpty) {
      print('handle empty email'); //TODO: handle empty email
      signingDataError('Email is required.');
      return;
    }

    final RegExp emailRegex =
        RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$'); //figured out how to regex, yay
    if (!emailRegex.hasMatch(email)) {
      print('handle invalid email'); //TODO: handle invalid email
      signingDataError('Email not valid.');
      return;
    }
    if (emails.contains(email)) {
      print('handle duplicate email'); //TODO: handle duplicate email
      signingDataError('Email is already in use.');
      return;
    }
    if (password.isEmpty) {
      print('handle empty password'); //TODO: handle empty password
      signingDataError('Password is required.');
      return;
    }
    if (checkPassword.isEmpty) {
      print('handle empty checkPassword'); //TODO: handle empty checkPassword
      signingDataError('Please confirm your password.');
      return;
    }
    if (password != checkPassword) {
      print('handle mismatched passwords'); //TODO: handle mismatched passwords
      signingDataError('Passwords do not match.');
      return;
    }

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

    //TODO: Add error handling for response codes

    print(response.statusCode);
    //100-199 are informational (not used?) and 300-399 are redirection (also not used?)
    //Values between 200 and 299 are successful
    //Values between 400 and 499 are client errors
    //Values between 500 and 599 are server errors

    print(json.decode(response.body)['name']);
    //Returns "name": "-key" if successful as well

    widget.doLogin();
  }

  void _switchSigning() {
    setState(() {
      _signUp = !_signUp;
    });
  }

  @override
  void dispose() {
    //Get rid of controllers and nodes when they're not used any more
    _emailController.dispose();
    _passwordController.dispose();
    _passwordMatchingController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        //TODO: Make text obscurable/visible
        child: _signUp
            ? signIn(
                menuStyle,
                _emailController,
                _passwordController,
                signUserIn,
                _switchSigning,
              )
            : signUp(
                menuStyle,
                _usernameController,
                _emailController,
                _passwordController,
                _passwordMatchingController,
                _createUser,
                _switchSigning,
              ),
      ),
    );
  }
}
