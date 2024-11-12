import 'package:flutter/material.dart';

Widget debugLogin(void Function() forceLogin) {
  return ElevatedButton(
    onPressed: forceLogin,
    child: const Text('Debug Login'),
  );
}
