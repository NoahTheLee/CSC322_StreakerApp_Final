import 'package:flutter/material.dart';
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

//Returning a string of tasks and their boolean values
Future<Map<String, bool>> getTasks(String uid) async {
  late Map<String, bool> tasks = {};
  //Reach out to Firebase
  //Use UID to get the specific user's tasks
  //Compile list
  //Return list

  //TODO: This might brick, do testing later
  for (final item in (await getResponse()).entries) {
    if (item.key == uid) {
      item.value['Data'].forEach((key, value) {
        tasks[key] = value;
      });
    }
  }

  return tasks;
}

//Adding a task to the user's list
void addTask(String uid, String task, BuildContext context) async {
  //Reach out to Firebase
  //Use UID to get specific user's address of tasks
  //Append task to list
  //Return positive?

  //Handle empty task, show dialogue, do not pass go, do not collect $200
  if (task.isEmpty || task == '') {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No task Provided'),
          content: const Text('Please provide a task to add.'),
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
    return;
  }

  http.patch(
    Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
        'Users/$uid/Data.json'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({task: false}),
  );
}

//Removing a task from the user's list
void removeTask(String uid, String task, BuildContext context) {
  //Reach out to Firebase
  //Use UID to get specific user's address of tasks
  //Remove task from list
  //Return positive?

  //Handle empty task, show dialogue, do not pass go, do not collect $200
  if (task.isEmpty || task == '') {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No task Provided'),
          content: const Text('Please provide a task to add.'),
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
    return;
  }

  http.delete(
    Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
        'Users/$uid/Data/$task.json'), //Copilot saved my butt ty Copilot ily
    headers: {
      'Content-Type': 'application/json',
    },
  );
}

//Updating a task's status
void updateTask(String uid, String task, BuildContext context) async {
  //Reach out to Firebase
  //Use UID to get specific user's address of tasks
  //Update task in list
  //Return positive?

  if (task.isEmpty || task == '') {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No task Provided'),
          content: const Text('Please provide a task to add.'),
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
    return;
  }

  // Fetch the current value of the task
  final response = await http.get(
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
    Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
        'Users/$uid/Data.json'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({task: newValue ? true : false}),
  );
}
