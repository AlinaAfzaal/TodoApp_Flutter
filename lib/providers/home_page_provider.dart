import 'package:flutter/material.dart';
import '../model/todoItem.dart';

class HomePageProvider with ChangeNotifier{

  List<ToDoItem> todoList = [
    ToDoItem(title: 'Coding', isCompleted: false),
    ToDoItem(title: 'Complete Task of freeCodeCamp', isCompleted: true),
    ToDoItem(title: 'Move Card to ReviewCoding Board', isCompleted: false),
  ];
  List<ToDoItem> get incompleteItems =>
      todoList.where((item) => !item.isCompleted).toList();

  List<ToDoItem> get completeItems =>
      todoList.where((item) => item.isCompleted).toList();

  int showItems = 0;
  String todoValue = "";
  String newValue ="";
  DateTime? reminder;
  List<ToDoItem>  currentList = [];

  HomePageProvider(){
    getCurrentList();
  }


  List<ToDoItem> getCurrentList(){
    if(showItems==0){currentList = todoList;}
    else if(showItems==1) {
      currentList = incompleteItems;
    } else if(showItems==2){ currentList = completeItems;}
    ChangeNotifier();
    notifyListeners();
    return currentList;

  }

  toggleCheckbox(int index){
    currentList[index].isCompleted = !currentList[index].isCompleted;
    ChangeNotifier();
    notifyListeners();

  }

  addTodoItem(String text){
    ToDoItem item = ToDoItem(
        title: text,
        reminder: reminder,
        isCompleted: false);
    todoList.add(item);
    reminder=null;
    ChangeNotifier();
    notifyListeners();

  }

  editTodoItem(int index){
    currentList[index].title = newValue;
    newValue = "";
    reminder = null;
    ChangeNotifier();
    notifyListeners();

  }

  deleteTodoItem(int index){
    currentList.removeAt(index);
    ChangeNotifier();
    notifyListeners();


  }

  String getFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    return formattedDate;
  }

}