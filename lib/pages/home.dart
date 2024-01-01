import 'package:flutter/material.dart';
import '../model/todoItem.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}
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
List<ToDoItem> currentList = todoList;


class HomePageState extends State<HomePage> {
  Color mainColor = const Color(0xFF0AB6AB);
  TextEditingController textEditingController = TextEditingController();
  String _newValue ="";
  DateTime? reminder;


  @override
  Widget build(BuildContext context) {

    if(showItems==0){currentList = todoList;}
    else if(showItems==1) {
      currentList = incompleteItems;
    } else if(showItems==2){ currentList = completeItems;}

    return Scaffold(
      appBar:
      AppBar(
        backgroundColor: mainColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showPopupMenu(context);
            },
          ),
        ],
        title: const Text('ToDo List', style: TextStyle(fontWeight: FontWeight.bold),),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Padding(
            padding: const EdgeInsets.only(left:20,bottom: 8.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(

                _getFormattedDate(),
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 15),
        color: Colors.black,
        child: ListView.builder(
          itemCount: currentList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentList[index].isCompleted = !currentList[index].isCompleted;
                });
              },
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      flex: 1,
                      onPressed: (BuildContext context) {
                        setState(() {
                          showDialog(

                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Edit ToDo Item'),
                                  content: TextFormField(
                                    initialValue:currentList[index].title,
                                    onChanged: (value){
                                      _newValue = value;
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Cancel', style: TextStyle(color: Colors.black54),),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          currentList[index].title = _newValue;
                                          _newValue = "";
                                          reminder = null;
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const Text('Edit'),
                                    ),
                                  ],
                                );
                              });
                        });
                      },
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white54,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      flex: 1,
                      onPressed: (BuildContext context) {
                        setState(() {
                         currentList.removeAt(index);
                        });
                      },
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white54,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child:
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 20),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  decoration: const BoxDecoration(
                      color: Color(0xFF201F1F),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child:ListTile(
                    leading: Checkbox(
                      value: currentList[index].isCompleted,
                      onChanged: (value) {
                        setState(() {
                          currentList[index].isCompleted = value!;
                        });
                      },
                    ),
                    title: Text(
                    currentList[index].title,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: currentList[index].isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                    subtitle: currentList[index].reminder!=null?Text(
            DateFormat('MMM d, yyyy HH:mm').format(currentList[index].reminder??DateTime.now()),
                      style: TextStyle(
                      color: mainColor,
                  ),


                  ): null

                ),
              ),
            ));
          },
        ),
      ),
      floatingActionButton:FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Add ToDo Item'),
                  content: SizedBox(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: TextFormField(
                            controller: textEditingController,
                            decoration: const InputDecoration(
                                hintText: 'Enter ToDo Item'),
                          ),
                        ),
                        TextButton(onPressed: () async {

                            reminder = await showOmniDateTimePicker
                              (context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2026),
                            );
                            setState(() {

                            });
                        }, child: Text(reminder==null?"Set Alarms": reminder.toString()))
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel', style: TextStyle(color: Colors.black54),),
                    ),
                    TextButton(
                      onPressed:() {
                        setState(() {
                          ToDoItem item = ToDoItem(
                              title: textEditingController.text,
                              reminder: reminder,
                              isCompleted: false);
                          todoList.add(item);
                          textEditingController.clear();
                          reminder=null;
                          Navigator.pop(context);
                        });
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
              });
        },
        // backgroundColor: mainColor,

        child: const Icon(Icons.add, color: Colors.black,),

      )



    );


  }
  void _showPopupMenu(BuildContext context) async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(double.infinity, 90, 0, double.infinity),

      items:const [
        PopupMenuItem(
          value: 0,
          child: Text('Show All Items'),
        ),
        PopupMenuItem(
          value: 1,
          child: Text('Show Incomplete Items'),
        ),
        PopupMenuItem(
          value: 2,
          child: Text('Show Complete Items'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          showItems = value;
        });
      }
    });
  }
  String _getFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    return formattedDate;
  }

}








