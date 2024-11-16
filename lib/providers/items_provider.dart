import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the state of your list as a simple List of Strings
class ItemList extends StateNotifier<List<String>> {
  ItemList()
      : super([
          'Task 1',
          'Task 2',
          'Task 3',
          'Task 4',
          'Task 5',
          'Task 6',
          'Task 7',
          'Task 8',
          'Task 9',
          'Task 10',
          'Task 11',
          'Really really really long ass task that has a lot of fatassery that I need to make sure doesn\'t overflow but it almost certainly will oh well',
        ]);

  void removeItem(int index) {
    state = [...state]..removeAt(index);
  }

  void addItem(String item) {
    state = [...state, item]; // Add the new item to the list
  }
}

// Create the StateNotifierProvider
final itemListProvider = StateNotifierProvider<ItemList, List<String>>((ref) {
  return ItemList();
});
