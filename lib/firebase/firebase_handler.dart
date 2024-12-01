import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

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
Future<void> updateResponse(context) async {
  //Nuke the lists
  keys.clear();
  emails.clear();
  passwords.clear();
  usernames.clear();

  //Pulling data with GET
  //Formatted as http.get(url)
  try {
    fullResponse = await http.get(firebaseUrl);
  } on SocketException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'No response from server, please try again later ||| Source: Problem with log in method');
    return; // Exit early if the request fails
  } on ClientException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'A client issue was encountered, please restart your application and try again ||| Source: Problem with log in method');
    return; // Exit early
  }

//pulls data from Firebase
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

//Function to update response
//This needs to be future, since it's an async function... Neat
//Super simple function to return a boolean if login is successful
Future<bool> checkLogin(
    {required String email, required String password, required context}) async {
  await updateResponse(context);

  //Even if not null, might not be in database

  if (!(email.isEmpty || password.isEmpty || !emails.contains(email)) &&
      passwords[emails.indexOf(email)] == password) {
    return true;
  } else {
    return false;
  }
}

//Returning a string of tasks and their boolean values
//Trycatch implemented in roundabout method
Future<Map<String, bool>> getTasks(
    {required String uid, required BuildContext context}) async {
  late Map<String, bool> tasks = {};
  //Reach out to Firebase
  //Use UID to get the specific user's tasks
  //Compile list
  //Return list

  try {
    for (final item
        in (await (json.decode((await http.get(firebaseUrl)).body))).entries) {
      if (item.key == uid) {
        item.value['Data'].forEach((key, value) {
          tasks[key] = value;
        });
      }
    }
  } on NoSuchMethodError {
    tasks = {};
  } on SocketException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'No response from server, please try again later ||| Source: Problem retrieving task list from Firebase');
  } on ClientException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'A client issue was encountered, please restart your application and try again ||| Source: Problem retrieving task list from Firebase');
  }

  return tasks;
}

//Trycatch not needed, relies on getTasks
Future<List<String>> getTaskNames(
    {required String uid, required BuildContext context}) async {
  final tasks = await getTasks(uid: uid, context: context);
  return tasks.keys.toList();
}

//Trycatch not needed, relies on getTasks
Future<List<bool>> getTaskStatuses(
    {required String uid, required BuildContext context}) async {
  final tasks = await getTasks(uid: uid, context: context);
  return tasks.values.toList();
}

void resetTasks({required String uid, required BuildContext context}) async {
  //Reach out to Firebase
  //Use UID to get specific user's address of tasks
  //Set status of all tasks to false

  //Well that went well

  for (final task in await getTaskNames(uid: uid, context: context)) {
    try {
      await http.patch(
        Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
            'Users/$uid/Data.json'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({task: false}),
      );
    } on SocketException {
      Navigator.pushNamed(context, '/error',
          arguments:
              'No response from server, please try again later ||| Source: A problem was encountered while changing the state of one or multiple tasks');
    } on ClientException {
      Navigator.pushNamed(context, '/error',
          arguments:
              'A client issue was encountered, please restart your application and try again ||| Source: A problem was encountered while changing the state of one or multiple tasks');
    }
  }
}

//Adding a task to the user's list
//Trycatch implemented
Future<void> addTask(
    {required String uid,
    required String task,
    required BuildContext context}) async {
  //Reach out to Firebase
  //Use UID to get specific user's address of tasks
  //Append task to list
  //Return positive?

  try {
    await http.patch(
      Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
          'Users/$uid/Data.json'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({task: false}),
    );
  } on SocketException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'No response from server, please try again later ||| Source: Adding task to Firebase');
    return; // Exit early if the request fails
  } on ClientException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'A client issue was encountered, please restart your application and try again ||| Source: Adding task to Firebase');
    return; // Exit early
  }
}

//Removing a task from the user's list
//Trycatch implemented
void removeTask(
    {required String uid,
    required String task,
    required BuildContext context}) async {
  //Reach out to Firebase
  //Use UID to get specific user's address of tasks
  //Remove task from list
  //Return positive?

  try {
    await http.delete(
      Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
          'Users/$uid/Data/$task.json'), //Copilot saved my butt ty Copilot ily
      headers: {
        'Content-Type': 'application/json',
      },
    );
  } on SocketException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'No response from server, please try again later ||| Source: Removing task from Firebase');
    return; // Exit early if the request fails
  } on ClientException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'A client issue was encountered, please restart your application and try again ||| Source: Removing task from Firebase');
    return; // Exit early
  }
}

//Updating a task's status
//Trycatch implemented
void updateTask(
    {required String uid,
    required String task,
    required BuildContext context}) async {
  //Reach out to Firebase
  //Use UID to get specific user's address of tasks
  //Update task in list
  //Return positive?

  // Fetch the current value of the task
  try {
    final response = await http.get(
      //Implement either a call to the "error" function, or determine if forced data is applicable
      Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
          'Users/$uid/Data/$task.json'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final currentValue = json.decode(response.body);

    // Toggle the value
    final newValue = !(currentValue as bool);

    // Update the task with the new value
    await http.patch(
      //Implement either a call to the "error" function, or determine if forced data is applicable
      Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
          'Users/$uid/Data.json'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({task: newValue ? true : false}),
    );
  } on SocketException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'No response from server, please try again later ||| Source: Updating task state in Firebase');
    return; // Exit early if the request fails
  } on ClientException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'A client issue was encountered, please restart your application and try again ||| Source: Updating task state in Firebase');
    return; // Exit early
  }
}

Future<void> incStreak(
    {required String uid, required BuildContext context}) async {
  //Pull data from Firebase, targeting the streak counter the given user
  try {
    final response = await http.get(
      Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
          'Users/$uid/Streak.json'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    //Decode that value into an integer
    final currentStreak = json.decode(response.body);

    //Increment the streak counter by one
    await http.patch(
      Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
          'Users/$uid.json'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'Streak': currentStreak + 1}),
    );
  } on SocketException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'No response from server, please try again later ||| Source: A problem was encountered when incrementing Streak on Firebase');
    return; // Exit early if the request fails
  } on ClientException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'A client issue was encountered, please restart your application and try again ||| Source: A problem was encountered when incrementing Streak on Firebase');
    return; // Exit early
  }
}

Future<void> resetStreak(
    {required String uid, required BuildContext context}) async {
  //Don't care what value is stored, just want to wipe it to 0
  try {
    await http.patch(
      Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
          'Users/$uid.json'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'Streak': 1}),
    );
  } on SocketException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'No response from server, please try again later ||| Source: A problem was encountered when resetting Streak on Firebase');
    return; // Exit early if the request fails
  } on ClientException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'A client issue was encountered, please restart your application and try again ||| Source: A problem was encountered when resetting Streak on Firebase');
    return; // Exit early
  }
}

Future<int> getStreak(
    {required String uid, required BuildContext context}) async {
  //Pull data from Firebase, targeting the streak counter the given user
  try {
    final response = await http.get(
      Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
          'Users/$uid/Streak.json'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    //Decode that value into an integer
    final currentStreak = json.decode(response.body);

    //Return the streak counter
    return currentStreak;
  } on SocketException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'No response from server, please try again later ||| Source: A problem was encountered when retrieving Streak from Firebase');
    return 0;
  } on ClientException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'A client issue was encountered, please restart your application and try again ||| Source: A problem was encountered when retrieving Streak from Firebase');
    return 0;
  }
}

// Function to compare two dates
//Trycatch not needed
bool hasExceededHours(DateTime storedDate, int hoursDifference) {
  DateTime currentDate = DateTime.now();
  Duration difference = currentDate.difference(storedDate);

  // Check if the difference exceeds the given hours
  return difference.inHours > hoursDifference;
}

// Sending the current date to uid
void sendDate({required String uid, required BuildContext context}) async {
  try {
    await http.patch(
      Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
          'Users/$uid.json'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'Streak Last Updated': DateTime.now().toString()}),
    );
  } on SocketException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'No response from server, please try again later ||| Source: A problem was encountered when sending current date to Firebase');
  } on ClientException {
    Navigator.pushNamed(context,
        'A client issue was encountered, please restart your application and try again ||| Source: A problem was encountered when sending current date to Firebase');
  }
}

// Pull date from uid
//Trycatch implemented
Future<String> getDate(
    {required String uid, required BuildContext context}) async {
  try {
    final response = await http.get(
      Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
          'Users/$uid/Streak Last Updated.json'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final storedDate = json.decode(response.body);

    return storedDate;
  } on SocketException {
    Navigator.pushNamed(context, '/error',
        arguments:
            'No response from server, please try again later ||| Source: Retreiving date from Firebase');
    return ''; // Exit early if the request fails
  } on ClientException {
    Navigator.pushNamed(context,
        'A client issue was encountered, please restart your application and try again ||| Source: Retrieving data from Firebase');
    return ''; // Exit early
  }
}

//Trycatch implemented
Future<String> timeUntil24Hours(
    {required String uid, required BuildContext context}) async {
  //Copilot my king :pray: :pray: :pray:
  // Retrieve the stored date from Firebase
  String retrievedDate = await getDate(
      uid: uid,
      context: context); // Ensure getDate is implemented to fetch from Firebase
  DateTime storedDate;
  try {
    storedDate = DateTime.parse(retrievedDate);
  } on FormatException {
    storedDate = DateTime(0000, 00, 00);
  }

  // Get the current date and time
  DateTime currentDate;
  try {
    currentDate = DateTime.now();
  } on FormatException {
    currentDate = DateTime(0000, 00, 00);
  }

  // Calculate when 24 hours have passed since the stored date
  DateTime targetDate = storedDate.add(const Duration(hours: 24));

  // Find the difference between the target date and the current date
  Duration timeRemaining = targetDate.difference(currentDate);

  // Ensure the time is not negative
  if (timeRemaining.isNegative) {
    return "00:00:00"; // Return 0 if 24 hours have already passed
  }

  // Format the remaining time as HH:mm:ss
  int hours = timeRemaining.inHours;
  int minutes = timeRemaining.inMinutes % 60;
  int seconds = timeRemaining.inSeconds % 60;

  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
}

//Compare stored date in uid to current date
//Want to build this to have a hardcoded date difference so it is adjustable
//Trycatch implemented
Future<bool> compareDates(
    {required String uid, required BuildContext context}) async {
  //Get the stored date
  int hoursToCompare = 24;
  String retrievedDate = await getDate(uid: uid, context: context);
  DateTime storedDate = DateTime.parse(retrievedDate);
  if (hasExceededHours(storedDate, hoursToCompare)) {
    //Return true
    return true;
  } else {
    //Return false
    return false;
  }
}
