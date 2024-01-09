class ToDoItem {
  int? id=0;
  String title;
  DateTime? reminder;
  bool isCompleted;

  ToDoItem({required this.title, required this.isCompleted, this.reminder, this.id});
  factory ToDoItem.fromSqfliteDatabase(Map<String, dynamic> map) {
    try {
      return ToDoItem(
        id: map['id'],
        title: map['title'],
        isCompleted: map['isCompleted'] == 1,
        reminder: map['reminder'] != null
            ? DateTime.parse(map['reminder'])
            : null,
      );
    } catch (e) {
      print('Error parsing date: $e');
      return ToDoItem(
        id: map['id'],
        title: map['title'],
        isCompleted: map['isCompleted'] == 1,
        reminder: null,
      );
    }

}}