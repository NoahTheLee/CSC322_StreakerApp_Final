import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csc322_streaker_final/providers/items_provider.dart';

// The ProfileScreen now accepts a 'uid' and uses Riverpod for items.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({
    super.key,
    required this.uid,
  });

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items =
        ref.watch(itemListProvider); // Watch the item list from the provider
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [
                const SizedBox(
                  height: 300,
                  width: double.infinity,
                ),
                Image.asset(
                  'assets/defaults/Default_Banner.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: MediaQuery.sizeOf(context).height / 7,
                  left: MediaQuery.sizeOf(context).width / 2 - 64,
                  child: CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(
                          'assets/defaults/Default_Profile_Picture.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: MediaQuery.sizeOf(context).width / 2 - uid.length * 9,
                  child: Text(
                    uid, // Temporary Username (use your actual username logic)
                    style: const TextStyle(
                      color: Color.fromARGB(255, 221, 218, 255),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
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
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 2 - 100,
              width: MediaQuery.sizeOf(context).width - 20,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(items[index]),
                          onDismissed: (direction) {
                            // Remove the item using Riverpod
                            ref
                                .read(itemListProvider.notifier)
                                .removeItem(index);
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color.fromARGB(255, 229, 126, 119),
                            ),
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
                                items[index],
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
            const SizedBox(height: 10),
            TextField(
              controller: controller,
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
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  // Add the new item to the list via Riverpod
                  ref.read(itemListProvider.notifier).addItem(value);
                  controller.clear(); // Clear the input field after adding
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
