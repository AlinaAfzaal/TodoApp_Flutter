import 'package:flutter/material.dart';
import 'package:todo_app/providers/home_page_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Color mainColor = const Color(0xFF0AB6AB);
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return
    Consumer<HomePageProvider>(
        builder: (context, provider, child){
          return Scaffold(
                appBar: AppBar(
                  backgroundColor: mainColor,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () async {
                        await showMenu(
                          context: context,
                          position: const RelativeRect.fromLTRB(
                              double.infinity, 90, 0, double.infinity),

                          items: const [
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
                            provider.showItems = value;
                            provider.getCurrentList();
                          }
                        });
                      },
                    ),
                  ],
                  title: const Text(
                    'ToDo List', style: TextStyle(fontWeight: FontWeight.bold),),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(30.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 8.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          provider.getFormattedDate(),
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

                    itemCount: provider.currentList.length,
                    itemBuilder: (context, index) {

                      return GestureDetector(
                          onTap: () {
                            provider.toggleCheckbox(index);
                          },
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  flex: 1,
                                  onPressed: (BuildContext context) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Edit ToDo Item'),
                                            content: TextFormField(
                                              initialValue: provider
                                                  .currentList[index].title,
                                              onChanged: (value) {
                                                provider.newValue = value;
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Cancel', style: TextStyle(
                                                    color: Colors.black54),),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  provider.editTodoItem(index);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Edit'),
                                              ),
                                            ],
                                          );
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
                                    provider.deleteTodoItem(index);
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
                              child: ListTile(
                                  leading: Checkbox(
                                    value: provider.currentList[index].isCompleted,
                                    onChanged: (value) {
                                      provider.toggleCheckbox(index);
                                    },
                                  ),
                                  title: Text(
                                    provider.currentList[index].title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: provider.currentList[index]
                                          .isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  subtitle: provider.currentList[index].reminder !=
                                      null ? Text(
                                    DateFormat('MMM d, yyyy HH:mm').format(provider
                                        .currentList[index].reminder ?? DateTime
                                        .now()),
                                    style: TextStyle(
                                      color: mainColor,
                                    ),
                                  ) : null

                              ),
                            ),
                          ));
                    },
                  ),
                ),
                floatingActionButton: FloatingActionButton(

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
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TextFormField(
                                      controller: textEditingController,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter ToDo Item'),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () async {
                                        provider.reminder = await showOmniDateTimePicker
                                          (context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2024),
                                          lastDate: DateTime(2026),
                                        );
                                      }, child: Text(provider.reminder == null
                                      ? "Set Alarms"
                                      : provider.reminder.toString())),
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
                                onPressed: () {
                                  provider.addTodoItem(textEditingController.text);

                                  Navigator.pop(context);
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
    );
  }


}
