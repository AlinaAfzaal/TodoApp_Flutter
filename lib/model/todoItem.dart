class ToDoItem {
  int id=0;
  String title;
  DateTime? reminder;
  bool isCompleted;

  ToDoItem({required this.title, required this.isCompleted, this.reminder});

  factory ToDoItem.fromSqfliteDatabase(Map<String, dynamic> map)=>ToDoItem(
      title: map['title'],
      isCompleted: map['isCompleted'],
      reminder: map['reminder'],
  );
}