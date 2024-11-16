import 'package:csc322_streaker_final/firebase%20stuff/firebase_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csc322_streaker_final/providers/tasks_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen(
      {super.key,
      required this.uid,
      required this.items,
      required this.removeItem});

  final String uid;

  final List<String> items;

  final Function(int) removeItem;

  @override
  ConsumerState<ProfileScreen> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  final String _banner = 'assets/defaults/Default_Banner.png';
  final String _profile = 'assets/defaults/Default_Profile_Picture.png';
  String _username = ''; //Temporary Username

  @override
  void initState() {
    super.initState();
    _username = usernames[keys.indexOf(widget.uid)];
    // final providedTasks = ref.watch(tasksProvider);
  }

  @override
  Widget build(BuildContext context) {
    final providiedTasks = ref.watch(tasksProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            Stack(
              ///////////////////////////////Banner Picture Location///////////////////////////
              children: [
                const SizedBox(
                  height: 300,
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
                Positioned(
                  bottom: 10,
                  left: MediaQuery.sizeOf(context).width / 2 -
                      _username.length * 9,
                  child: Text(
                    _username, //Temporary Username
                    style: const TextStyle(
                      color: Color.fromARGB(255, 221, 218, 255),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                ////////////////////////////////////////////////////////////////////////////////
              ],
            ),
            //////////////////////////////Items to Track Title//////////////////////////////////
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
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      //ListView.builder cannibalized from shopping app
                      itemCount: providiedTasks.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          //Make them dismissible
                          key: Key(
                            providiedTasks[index],
                          ),
                          onDismissed: (direction) {
                            //Get rid of the thing
                            //TODO: Remove from database
                            ref.read(tasksProvider.notifier).removeTask(index);
                          },
                          background: Container(
                            //Background for the dismissible
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color:
                                    const Color.fromARGB(255, 229, 126, 119)),
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
                                providiedTasks[index],
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
            const SizedBox(height: 10),
            TextField(
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
            /////////////////////////////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}
