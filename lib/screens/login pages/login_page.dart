import 'dart:convert';

import 'package:csc322_streaker_final/firebase%20stuff/firebase_handler.dart';
import 'package:csc322_streaker_final/screens/login%20pages/sign_in.dart';
import 'package:csc322_streaker_final/screens/login%20pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.doLogin, required this.changeUid});

  final void Function(String) changeUid;

  final void Function() doLogin;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  _changeUid(String email) {
    String newUid = keys[emails.indexOf(email)];

    print('New UID: $newUid'); //TODO: remove this

    widget.changeUid(newUid);
  }

  //Color of menu, easy to change for theming
  final Color menuStyle = Colors.white;
  //Controllers for getting email and password data
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordMatchingController =
      TextEditingController();
  bool _passwordVisible = true;

  //empty variables for email and password
  bool _signUp = true;

  //Empty strings to store data
  var email = '';
  var checkPassword = '';
  var password = '';
  var username = '';

  //Firebase URL
  //Formatted as Uri.https('link', 'path.json')

  void setValues() {
    //Update values of email, password, and username
    email = _emailController.text;
    password = _passwordController.text;
    checkPassword = _passwordMatchingController.text;
    username = _usernameController.text;
  }

  void forceLogin() async {
    //TODO: Remove this function
    print('Forcing login as TestUser...');

    setValues();

    email = "test@domain.gov";
    password = "Testing123";
    if (await checkLogin(email, password)) {
      _changeUid(email);
      widget
          .doLogin(); //Moves to app home page, should only be called if login is successful
    }
  }

  void signUserIn() async {
    //Empty placeholder to print values to the debug console.
    //Later, this should check firebase for login status
    setValues();

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
    if (password.isEmpty) {
      print('handle empty password'); //TODO: handle empty password
      signingDataError('Password is required.');
      return;
    }

    if (await checkLogin(email, password)) {
      _changeUid(email);
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

  void togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final activeFilters = ref.watch(uidProvider);
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
                forceLogin,
                togglePasswordVisibility,
                _passwordVisible,
              )
            : signUp(
                menuStyle,
                _usernameController,
                _emailController,
                _passwordController,
                _passwordMatchingController,
                _createUser,
                _switchSigning,
                togglePasswordVisibility,
                _passwordVisible,
              ),
      ),
    );
  }
}
