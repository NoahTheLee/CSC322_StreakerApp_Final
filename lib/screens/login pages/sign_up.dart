import 'package:flutter/material.dart';

Widget signUp({
  required Color menuStyle,
  required TextEditingController usernameController,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController passwordMatchingController,
  required void Function() switchToSignIn,
  required void Function() togglePasswordVisibility,
  required void Function() createUser,
  required bool passwordVisible,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextField(
        controller: usernameController,
        decoration: InputDecoration(
          labelText: 'Username',
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
        obscureText: passwordVisible,
      ),
      const SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: () {
          createUser();
          switchToSignIn();
        },
        child: const Text('Sign Up'),
      ),
      TextButton(
        onPressed: switchToSignIn,
        child: const Text('Already have an account? Sign in!'),
      ),
    ],
  );
}
