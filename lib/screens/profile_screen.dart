import 'package:csc322_streaker_final/firebase/firebase_handler.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.uid});

  final String uid;

  @override
  State<ProfileScreen> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  final String _banner = 'assets/defaults/Default_Banner.png';
  final String _profile = 'assets/defaults/Default_Profile_Picture.png';
  String _username = ''; //Temporary Username

  final TextEditingController _taskName = TextEditingController();

  List<String> tasks = [];

  bool tasksEmpty = false;

  @override
  void initState() {
    _username = usernames[keys.indexOf(widget.uid)];
    setTaskNames();

    super.initState();
  }

  void checkEmpty() {
    if (tasks.isEmpty) {
      setState(() {
        tasksEmpty = true;
      });
    } else {
      setState(() {
        tasksEmpty = false;
      });
    }
  }

  @override
  void dispose() {
    _taskName.dispose();
    super.dispose();
  }

  void setTaskNames() async {
    await getTaskNames(uid: widget.uid, context: context).then((value) {
      setState(() {
        tasks = value;
      });
      checkEmpty();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            Stack(
              ///////////////////////////////Banner Picture Location///////////////////////////
              children: [
                const SizedBox(
                  height: 255,
                  width: double.infinity,
                ),
                Image.asset(
                  _banner,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                ////////////////////////////////////////////////////////////////////////////////
                /////////////////////////////Profile Picture Location///////////////////////////
                Positioned(
                  top: MediaQuery.sizeOf(context).height / 7,
                  left: MediaQuery.sizeOf(context).width / 2 - 64,
                  child: CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(_profile),
                    ),
                  ),
                ),
                ////////////////////////////////////////////////////////////////////////////////
                /////////////////////////////Username Location//////////////////////////////////
                ////////////////////////////////////////////////////////////////////////////////
              ],
            ),
            //////////////////////////////Items to Track Title//////////////////////////////////
            Text(
              _username, //Temporary Username
              style: const TextStyle(
                color: Color.fromARGB(255, 221, 218, 255),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Items to Track',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial Black',
              ),
            ),
            ////////////////////////////////////////////////////////////////////////////////////
            //////////////////////////////Items to Track List///////////////////////////////////
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 2 - 100,
              width: MediaQuery.sizeOf(context).width - 20,
              child: tasksEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          color: Colors.white,
                          size: 50,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Add tasks to get started!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            //ListView.builder cannibalized from shopping app
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                //Make them dismissible
                                key: Key(
                                  tasks[index],
                                ),
                                onDismissed: (direction) {
                                  //Get rid of the thing
                                  removeTask(
                                      uid: widget.uid,
                                      task: tasks[index],
                                      context: context);
                                  setState(() {
                                    tasks.removeAt(index);
                                  });
                                  checkEmpty();
                                },
                                background: Container(
                                  //Background for the dismissible
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: const Color.fromARGB(
                                          255, 229, 126, 119)),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  title: Center(
                                    child: Text(
                                      //The item itself, just a text widget
                                      tasks[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
            ////////////////////////////////////////////////////////////////////////////////////
            //////////////////////////////Add New Item//////////////////////////////////////////
            Expanded(
              child: Container(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(
                        color: Color.fromARGB(255, 166, 166, 166)),
                    controller: _taskName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Enter your new item here',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 166, 166, 166),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    String task = _taskName.text;
                    if (task.isEmpty || task == '') {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('No task Provided'),
                            content:
                                const Text('Please provide a task to add.'),
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
                    if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(task)) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Invalid task'),
                            content: const Text(
                                'Tasks can only contain alphanumeric characters and spaces.'),
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
                    _taskName.clear();
                    await addTask(
                        uid: widget.uid, task: task, context: context);
                    setState(() {
                      tasks.add(task);
                    });
                    checkEmpty();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            /////////////////////////////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}
