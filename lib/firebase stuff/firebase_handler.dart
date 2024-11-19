import 'package:http/http.dart' as http;
import 'dart:convert';

//Empty lists to store data from Firebase
final List<String> keys = [];
final List<String> emails = [];
final List<String> passwords = [];
final List<String> usernames = [];
//fullResponse initialized as empty, but will store raw data from Firebase
late http.Response fullResponse;
//responseData initialized as empty, will store decoded data from Firebase
Map<String, dynamic> responseData = {};
//NOTE: The inner map will PROBABLY stay as Dynamic since this might also store images???

//Firebase URL
final Uri firebaseUrl = Uri.https(
    'csc322-streaker-final-default-rtdb.firebaseio.com', 'Users.json');

//Function to update response
//This needs to be future, since it's an async function... Neat
Future<void> updateResponse() async {
  //Nuke the lists
  keys.clear();
  emails.clear();
  passwords.clear();
  usernames.clear();

  //Pulling data with GET
  //Formatted as http.get(url)
  fullResponse = await http.get(firebaseUrl); //pulls data from Firebase
  //fullResponse should NEVER be used for anything at all ever since it's "junk" data

  responseData =
      json.decode(fullResponse.body); //Converts data into a KVP of KVPs (bruh)

  for (final item in responseData.entries) {
    keys.add(item.key);
    emails.add(item.value['email']);
    passwords.add(item.value['password']);
    usernames.add(item.value['username']);
  }
}

Future<Map<String, dynamic>> getResponse() async {
  return responseData = json.decode((await http.get(firebaseUrl)).body);
}

//Function to update response
//This needs to be future, since it's an async function... Neat
//Super simple function to return a boolean if login is successful
Future<bool> checkLogin(String email, String password) async {
  await updateResponse();

  //Even if not null, might not be in database

  if (!(email.isEmpty || password.isEmpty || !emails.contains(email)) &&
      passwords[emails.indexOf(email)] == password) {
    return true;
  } else {
    return false;
  }
}
