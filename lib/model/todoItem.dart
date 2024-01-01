class ToDoItem {
  String title;
  DateTime? reminder;
  bool isCompleted;

  ToDoItem({required this.title, required this.isCompleted, this.reminder});
}