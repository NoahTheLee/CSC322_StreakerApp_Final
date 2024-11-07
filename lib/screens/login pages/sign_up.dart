import 'package:flutter/material.dart';

Widget signUp(
  Color menuStyle,
  TextEditingController emailController,
  TextEditingController passwordController,
  TextEditingController passwordMatchingController,
  void Function() checkLogin,
  void Function() switchToSignIn,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(color: menuStyle),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: menuStyle),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: menuStyle),
          ),
        ),
        style: TextStyle(color: menuStyle),
      ),
      const SizedBox(height: 16.0),
      TextField(
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(color: menuStyle),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: menuStyle),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: menuStyle),
          ),
        ),
        style: TextStyle(color: menuStyle),
        obscureText: true,
      ),
      const SizedBox(height: 16.0),
      TextField(
        controller: passwordMatchingController,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          labelStyle: TextStyle(color: menuStyle),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: menuStyle),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: menuStyle),
          ),
        ),
        style: TextStyle(color: menuStyle),
        obscureText: true,
      ),
      const SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: checkLogin,
        child: const Text('Sign Up'),
      ),
      TextButton(
        onPressed: switchToSignIn,
        child: const Text('Already have an account? Sign in!'),
      ),
    ],
  );
}
