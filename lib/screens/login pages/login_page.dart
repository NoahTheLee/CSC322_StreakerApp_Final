import 'dart:convert';
import 'dart:io';

import 'package:csc322_streaker_final/firebase/firebase_handler.dart';
import 'package:csc322_streaker_final/screens/login%20pages/sign_in.dart';
import 'package:csc322_streaker_final/screens/login%20pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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

  //Boolean to handle password visibility, passed through to sign in and sign up
  bool _passwordVisible = true;

  //empty variables for email and password
  bool _signUp = true;

  //Empty strings to store data
  var email = '';
  var checkPassword = '';
  var password = '';
  var username = '';

  void setValues() {
    //Update values of email, password, password checker, and username
    email = _emailController.text;
    password = _passwordController.text;
    checkPassword = _passwordMatchingController.text;
    username = _usernameController.text;
  }

  void forceLogin() async {
    //TODO: Remove this function when testing is complete

    setValues();

    email = "test@domain.net";
    password = "12345";
    if (await checkLogin(email: email, password: password, context: context)) {
      _changeUid(email);
      widget
          .doLogin(); //Moves to app home page, should only be called if login is successful
    }
  }

  void signUserIn() async {
    setValues();

    //Do a bunch of checks on input data to make sure it's valid
    if (email.isEmpty) {
      signingDataError('Email is required.');
      return;
    }
    final RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(email)) {
      signingDataError('Email not valid.');
      return;
    }
    if (password.isEmpty) {
      signingDataError('Password is required.');
      return;
    }

    if (await checkLogin(email: email, password: password, context: context)) {
      _changeUid(email);
      widget.doLogin();
    }
  }

  //Simple function to display error message, dependant on error. Used in multiple places
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
    await updateResponse(context);
    setValues();

    if (username.isEmpty) {
      signingDataError('Username is required.');
      return;
    }
    if (usernames.contains(username)) {
      signingDataError('Username is already in use.');
      return;
    }
    if (email.isEmpty) {
      signingDataError('Email is required.');
      return;
    }

    final RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(email)) {
      signingDataError('Email not valid.');
      return;
    }
    if (emails.contains(email)) {
      signingDataError('Email is already in use.');
      return;
    }
    if (password.isEmpty) {
      signingDataError('Password is required.');
      return;
    }
    if (checkPassword.isEmpty) {
      signingDataError('Please confirm your password.');
      return;
    }
    if (password != checkPassword) {
      signingDataError('Passwords do not match.');
      return;
    }

    try {
      await http.post(
        firebaseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          //Content needs key-value pairs ('type': 'value')
          {
            'Streak': 0,
            'Streak Last Updated':
                DateTime.now().subtract(const Duration(hours: 24)).toString(),
            'email': email,
            'password': password,
            'username': username,
          },
        ),
      );
    } on SocketException {
      Navigator.pushNamed(context, '/error',
          arguments:
              'No response from server, please try again later ||| Source: Unable to communicate with server and add user to Firebase');
      return; // Exit early if the request fails
    } on ClientException {
      Navigator.pushNamed(context, '/error',
          arguments:
              'A client issue was encountered, please restart your application and try again ||| Source: Unable to communicate with server and add user to Firebase');
      return; // Exit early
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Account created!'),
          content: const Text('Try logging in with your new account.'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                menuStyle: menuStyle,
                usernameController: _usernameController,
                emailController: _emailController,
                passwordController: _passwordController,
                passwordMatchingController: _passwordMatchingController,
                switchToSignIn: _switchSigning,
                togglePasswordVisibility: togglePasswordVisibility,
                passwordVisible: _passwordVisible,
                createUser: _createUser,
              ),
      ),
    );
  }
}
