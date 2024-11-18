class Task {
  Task(this.taskName);

  String taskName;
  bool isDone = false;

  void toggleDone() {
    isDone = !isDone;
  }
}
