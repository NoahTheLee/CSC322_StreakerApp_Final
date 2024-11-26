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

Future<List<String>> getTaskNames(String uid) async {
  final tasks = await getTasks(uid);
  return tasks.keys.toList();
}

Future<List<bool>> getTaskStatuses(String uid) async {
  final tasks = await getTasks(uid);
  return tasks.values.toList();
}

//Adding a task to the user's list
void addTask(String uid, String task) async {
  //Reach out to Firebase
  //Use UID to get specific user's address of tasks
  //Append task to list
  //Return positive?

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
void removeTask(String uid, String task) {
  //Reach out to Firebase
  //Use UID to get specific user's address of tasks
  //Remove task from list
  //Return positive?

  http.delete(
    Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
        'Users/$uid/Data/$task.json'), //Copilot saved my butt ty Copilot ily
    headers: {
      'Content-Type': 'application/json',
    },
  );
}

//Updating a task's status
void updateTask(String uid, String task) async {
  //Reach out to Firebase
  //Use UID to get specific user's address of tasks
  //Update task in list
  //Return positive?

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

void incStreak(String uid) async {
  //Pull data from Firebase, targeting the streak counter the given user
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
  http.patch(
    Uri.https(
        'csc322-streaker-final-default-rtdb.firebaseio.com', 'Users/$uid.json'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({'Streak': currentStreak + 1}),
  );
}

void resetStreak(String uid) async {
  //Don't care what value is stored, just want to wipe it to 0
  http.patch(
    Uri.https(
        'csc322-streaker-final-default-rtdb.firebaseio.com', 'Users/$uid.json'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({'Streak': 0}),
  );
}

// Function to compare two dates
bool hasExceededHours(DateTime storedDate, int hoursDifference) {
  DateTime currentDate = DateTime.now();
  Duration difference = currentDate.difference(storedDate);

  // Check if the difference exceeds the given hours
  return difference.inHours > hoursDifference;
}

// Sending the current date to uid
void sendDate(String uid) async {
  http.patch(
    Uri.https(
        'csc322-streaker-final-default-rtdb.firebaseio.com', 'Users/$uid.json'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({'Streak Last Updated': DateTime.now().toString()}),
  );
}

// Pull date from uid
Future<String> getDate(String uid) async {
  final response = await http.get(
    Uri.https('csc322-streaker-final-default-rtdb.firebaseio.com',
        'Users/$uid/Streak Last Updated.json'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  final storedDate = json.decode(response.body);

  return storedDate;
}

//Compare stored date in uid to current date
//Want to build this to have a hardcoded date difference so it is adjustable
Future<bool> compareDates(String uid) async {
  //Get the stored date
  int hoursToCompare = 24;
  String retrievedDate = await getDate(uid);
  DateTime storedDate = DateTime.parse(retrievedDate);
  if (hasExceededHours(storedDate, hoursToCompare)) {
    //Return true
    return true;
  } else {
    //Return false
    return false;
  }
}
