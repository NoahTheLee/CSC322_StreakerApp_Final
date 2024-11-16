import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksNotifier extends StateNotifier<List<String>> {
  TasksNotifier()
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
          'Really really really really long something just to make sure it doesn\'t brick with an absolutely OBESE muf of a string lol',
        ]);

  void addTask(String task) {
    state = [...state, task];
  }

  // void removeTask(String task) { //TODO: Determine if this is the correct implementation or not... || Refer to 187 8m
  // state = List.from(state)..remove(task);}

  void removeTask(int index) {
    state =
        state.where((fullList) => state.indexOf(fullList) != index).toList();
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<String>>((ref) {
  return TasksNotifier();
});
