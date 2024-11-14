import 'package:csc322_streaker_final/Testing/debug_file.dart';
import 'package:flutter/material.dart';

Widget signIn(
    Color menuStyle,
    TextEditingController emailController,
    TextEditingController passwordController,
    void Function() checkLogin,
    void Function() switchToSignUp,
    void Function() forceLogin,
    void Function() togglePasswordVisibility,
    bool passwordVisible) {
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
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisible ? Icons.visibility_off : Icons.visibility,
              color: menuStyle,
            ),
            onPressed: togglePasswordVisibility,
          ),
        ),
        style: TextStyle(color: menuStyle),
        obscureText: passwordVisible,
      ),
      const SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: checkLogin,
        child: const Text('Log In'),
      ),
      TextButton(
        onPressed: switchToSignUp,
        child: const Text('Don\'t have an account? Create one!'),
      ),
      debugLogin(forceLogin),
    ],
  );
}
