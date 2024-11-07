import 'package:csc322_streaker_final/screens/login%20pages/sign_in.dart';
import 'package:csc322_streaker_final/screens/login%20pages/sign_up.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.doLogin});

  final void Function() doLogin;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Color of menu, easy to change for theming
  final Color menuStyle = Colors.white;
  //Controllers for getting email and password data
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordMatchingController =
      TextEditingController();

  //empty variables for email and password
  String _email = '';
  String _password = '';
  bool _signUp = false;

  @override
  void initState() {
    super.initState();
  }

  void _checkLogin() {
    //Empty placeholder to print values to the debug console.
    //Later, this should check firebase for login status
    _email = _emailController.text;
    _password = _passwordController.text;
    print(
        'DEBUG DEBUG DEBUG ||| Email: $_email, Password: $_password ||| DEBUG DEBUG DEBUG');
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
    super.dispose();
  }

  //TODO: Consider implementing a widget for returning InputDecoration to clean up the decorations?

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
                _checkLogin,
                _switchSigning,
              )
            : signUp(
                menuStyle,
                _emailController,
                _passwordController,
                _passwordMatchingController,
                _checkLogin,
                _switchSigning,
              ),
      ),
    );
  }
}
