import 'package:flutter/material.dart';
import '../database/todo_db.dart';
import '../model/todoItem.dart';

class HomePageProvider with ChangeNotifier{

  TodoDB todoDB= TodoDB();
  List<ToDoItem> todoList=[];

  List<ToDoItem> get incompleteItems =>
      todoList.where((item) => !item.isCompleted).toList();

  List<ToDoItem> get completeItems =>
      todoList.where((item) => item.isCompleted).toList();

  int showItems = 0;
  String todoValue = "";
  String newValue ="";
  DateTime? reminder;
  List<ToDoItem>  currentList = [];

  HomePageProvider() {
    getCurrentList();
  }


  Future<List<ToDoItem>> getCurrentList() async {
    todoList = await todoDB.fetchAll();
    if(showItems==0){currentList =todoList;}
    else if(showItems==1) {
      currentList = incompleteItems;
    } else if(showItems==2){ currentList = completeItems;}
    notifyListeners();
    return currentList;

  }

  toggleCheckbox(int index) async {
    currentList[index].isCompleted = !currentList[index].isCompleted;
    await todoDB.updateCheck(id:currentList[index].id!,  check:currentList[index].isCompleted );
    notifyListeners();
  }

  Future<void> addTodoItem(String text) async {
    ToDoItem item = ToDoItem(
        title: text,
        reminder: reminder,
        isCompleted: false);
    todoList.add(item);
    await todoDB.create(title: text, reminder: reminder);
    getCurrentList();
    reminder=null;
    notifyListeners();

  }

  editTodoItem(int index) async {
    currentList[index].title = newValue;
    currentList[index].reminder = reminder;
    await todoDB.update(id: currentList[index].id!, title: currentList[index].title);
    getCurrentList();

    newValue = "";
    reminder = null;
    notifyListeners();
  }

  deleteTodoItem(int index) async {
    currentList.removeAt(index);
    await todoDB.delete(currentList[index].id!);
    getCurrentList();
    notifyListeners();
  }

  String getFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    return formattedDate;
  }

}