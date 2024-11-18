import 'package:csc322_streaker_final/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//TODOs:
//  Get list of users from firebase
//  Parse data
//  Grow list of users
//  Set data per user

List<User> users = [];

//Vars for Firebase
late http.Response fullResponse;
final Uri firebaseUrl = Uri.https(
    'csc322-streaker-final-default-rtdb.firebaseio.com', 'Users.json');
Map<String, dynamic> userResponseData = {};

void setUsers() async {
  //Nuke data for now?
  users.clear();

  //Pulling data with GET
  //Formatted as http.get(url)
  fullResponse = await http.get(firebaseUrl); //pulls data from Firebase
  //fullResponse should NEVER be used for anything at all ever since it's "junk" data

  userResponseData =
      json.decode(fullResponse.body); //Converts data into a KVP of KVPs (bruh)

  for (final item in userResponseData.entries) {
    users.add(
      User(
        uid: item.key,
        email: item.value['email'],
        password: item.value['password'],
        username: item.value['username'],
      ),
    );
  }
}

Future<User> findUser(String uid) async {
  setUsers();
  for (final user in users) {
    if (user.uid == uid) {
      print(
          'Email: ${user.email} | Password: ${user.password} | Username: ${user.username} | UID: ${user.uid}');
      return user;
    }
  }
  return User(uid: '', email: '', password: '', username: '');
}
