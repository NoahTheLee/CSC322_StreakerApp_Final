import 'dart:convert';

import 'package:csc322_streaker_final/firebase%20stuff/firebase_handler.dart';
import 'package:csc322_streaker_final/models/handlers/user_setter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TestingScreen2 extends StatefulWidget {
  TestingScreen2({super.key});

  final String uid = '-OBwH73--ukahPMF4pX-';

  @override
  _TestingScreen2State createState() => _TestingScreen2State();
}

class _TestingScreen2State extends State<TestingScreen2> {
  final TextEditingController taskName = TextEditingController();
  var task = '';

  @override
  dispose() {
    taskName.dispose();
    super.dispose();
  }

  //Returns a map of tasks and their completion status
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

  void addTask(String uid, String task) async {
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

  void removeTask(String uid, String task) {
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

  void updateTask(String uid, String task) async {
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

  void setValues() {
    task = taskName.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing Screen 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Text field for task name
            TextField(
              controller: taskName,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelText: 'Task Name',
              ),
            ),
            //Check data from Firebase
            TextButton(
              onPressed: () async {
                //TODO: Need loading method to fetch data

                //Function needs to await, since it returns a future
                await updateResponse();
                print('Raw data: $responseData');
                //Returns map of KVPs, which are themselves maps of KVPs
                print('Keys: $keys');
                print('Emails: $emails');
                print('Passwords: $passwords');
                print('Usernames: $usernames');
              },
              child: const Text('Retrieve data from Firebase'),
            ),
            //Reset basic user
            TextButton(
              child: const Text('Reset data'),
              onPressed: () async {
                //Testing with a different main header

                //Data sent with patch replaces or update given fields
                //If they exist, update. If they don't exist, set them

                //Data sent with PUT replaces the entire object
                final response = await http.put(
                  Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
                      'Users/${widget.uid}.json'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: json.encode(
                    //Content needs key-value pairs ('type': 'value')
                    {
                      'email': 'test@domain.net',
                      'password': "12345",
                      'username': "testuser",
                    },
                  ),
                );

                print(response.statusCode);

                //End of text button to-execute
              },
            ),
            //Send data to new field
            TextButton(
              child: const Text('Send new Task to Firebase'),
              onPressed: () async {
                setValues();
                //By targeting the database, then a userID, then a specific subfolder, can push a segment of data
                addTask(widget.uid, task);
                //End of text button to-execute
              },
            ),
            TextButton(
              onPressed: () async {
                setValues();
                removeTask(widget.uid, task);
              },
              child: const Text('Delete task from Firebase'),
            ),
            TextButton(
              onPressed: () async {
                setValues();
                updateTask(widget.uid, task);
              },
              child: const Text('Update task in Firebase'),
            ),
            TextButton(
              onPressed: () async {
                print(
                  (await getTasks(widget.uid),),
                );
              },
              child: const Text('Check data from Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}
