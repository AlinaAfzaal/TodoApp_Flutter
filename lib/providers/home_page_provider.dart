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

  List<ToDoItem> getCurrentList(){
    List<ToDoItem>  currentList = todoList;
    if(showItems==0){currentList = todoList;}
    else if(showItems==1) {
      currentList = incompleteItems;
    } else if(showItems==2){ currentList = completeItems;}
    return currentList;

  }

  toggleCheckbox(int index){

    getCurrentList()[index].isCompleted = !getCurrentList()[index].isCompleted;
    ChangeNotifier();
  }

  addTodoItem(String text){
    ToDoItem item = ToDoItem(
        title: text,
        reminder: reminder,
        isCompleted: false);
    todoList.add(item);
    reminder=null;
    ChangeNotifier();
  }

  editTodoItem(int index){
    getCurrentList()[index].title = newValue;
    newValue = "";
    reminder = null;
    ChangeNotifier();
  }

  deleteTodoItem(int index){
    getCurrentList().removeAt(index);
    ChangeNotifier();

  }

  String getFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    return formattedDate;
  }

}