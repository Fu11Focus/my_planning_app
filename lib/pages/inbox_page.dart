// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ToDoDude/data/inbox.dart';
import 'package:ToDoDude/data/todo_list.dart';
import 'package:ToDoDude/my_icons_icons.dart';
import 'package:ToDoDude/util/color_palette.dart';
import 'package:ToDoDude/widgets/my_appbar.dart';
import 'package:ToDoDude/widgets/neomorphism_button.dart';
import 'package:ToDoDude/widgets/right_menu.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../widgets/neo_container.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

final _myBox = Hive.box('InboxListBox');
InboxList inboxDB = InboxList();
final _myBox2 = Hive.box('ToDoListBox');
TodoList todoDB = TodoList();
TextEditingController newTaskController = TextEditingController();

class _InboxState extends State<Inbox> {
  @override
  void initState() {
    if (_myBox.get('INBOXLIST') == null) {
      inboxDB.createInitialData();
    } else {
      inboxDB.loadData();
    }

    if (_myBox2.get('TODOLIST') == null) {
      todoDB.createInitialData();
    } else {
      todoDB.loadData();
    }
    super.initState();
  }

  DateTime dateForNewTask = DateTime.now();
  void _addTodoDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          titleTextStyle: TextStyle(color: txt),
          actionsPadding: const EdgeInsets.all(0),
          insetPadding: const EdgeInsets.only(top: 10, bottom: 300, left: 20, right: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.all(0),
          contentTextStyle: const TextStyle(color: txt),
          backgroundColor: bg,
          elevation: 0,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(12), boxShadow: [
                  BoxShadow(color: shadowDark),
                  BoxShadow(color: bg, spreadRadius: -5, blurRadius: 5),
                ]),
                child: TextField(
                  controller: newTaskController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter a task',
                  ),
                  style: const TextStyle(color: txt),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20, top: 20),
              child: NeomorphismButton(
                action: () {
                  inboxDB.addNewItem(newTaskController.text);
                  setState(() {
                    newTaskController.clear();
                  });
                  Navigator.pop(context);
                },
                height: 40,
                width: 80,
                child: const Text('Add', style: TextStyle(color: txt, fontSize: 18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20, top: 20),
              child: NeomorphismButton(
                action: () {
                  setState(() {
                    newTaskController.clear();
                  });
                  Navigator.pop(context);
                },
                height: 40,
                width: 80,
                child: const Text('Cancel', style: TextStyle(color: txt, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(Function setDialogState) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  surface: Theme.of(context).scaffoldBackgroundColor,
                  primary: brand, // header background color
                  onPrimary: txt, // header text color
                  onSurface: txt, // body text color
                ),
            dialogBackgroundColor: Colors.white, // background color of the date picker dialog
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setDialogState(() {
        dateForNewTask = picked;
      });
    }
  }

  void _addToDoDialog(title, id) {
    newTaskController.text = title;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          actionsPadding: const EdgeInsets.all(0),
          insetPadding: const EdgeInsets.only(top: 10, bottom: 300, left: 20, right: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.all(0),
          contentTextStyle: const TextStyle(color: txt),
          backgroundColor: bg,
          elevation: 0,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 150,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(12), boxShadow: [
                    BoxShadow(color: shadowDark),
                    BoxShadow(color: bg, spreadRadius: -5, blurRadius: 5),
                  ]),
                  child: TextField(
                    readOnly: true,
                    controller: newTaskController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter a task',
                    ),
                    style: const TextStyle(color: txt),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: NeoContainer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Text(DateFormat('dd.MM.yyyy').format(dateForNewTask)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: NeomorphismButton(
                            action: () => _selectDate(setDialogState),
                            height: 30,
                            width: 100,
                            child: const Text('Select date',
                                style: TextStyle(
                                  color: txt,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ]),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20, top: 20),
              child: NeomorphismButton(
                action: () {
                  setState(() {
                    todoDB.addTodoItem(title, false, dateForNewTask);
                    inboxDB.inboxList.removeAt(inboxDB.inboxList.indexWhere((element) => element['id'] == id));
                    newTaskController.clear();
                  });
                  Navigator.pop(context);
                },
                height: 40,
                width: 80,
                child: const Text('Add', style: TextStyle(color: txt, fontSize: 18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20, top: 20),
              child: NeomorphismButton(
                action: () {
                  setState(() {
                    newTaskController.clear();
                  });
                  Navigator.pop(context);
                },
                height: 40,
                width: 80,
                child: const Text('Cancel', style: TextStyle(color: txt, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const RightMenu(thisPage: 'Inbox'),
      appBar: const MyAppBar(icon: Icons.inbox_outlined, text: 'Inbox'),
      body: inboxDB.inboxList.isEmpty
          ? Center(
              child: Text('Add another task without date for to do!', style: TextStyle(color: hintTxt, fontSize: 20)),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ListView.builder(
                  itemCount: inboxDB.inboxList.length,
                  primary: true,
                  itemBuilder: ((context, index) => Slidable(
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              autoClose: true,
                              onPressed: (context) => setState(() {
                                inboxDB.removeFromInbox(inboxDB.inboxList[index]['id']);
                              }),
                              icon: MyIcons.trash,
                              backgroundColor: bg,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                            onTap: () => _addToDoDialog(inboxDB.inboxList[index]['title'], inboxDB.inboxList[index]['id']),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: bg,
                                /*border: Border.all(color: shadowLight),*/ boxShadow: [BoxShadow(color: shadowDark, offset: Offset(5, 5), blurRadius: 10), BoxShadow(color: shadowLight, offset: Offset(-5, -5), blurRadius: 10)],
                                // gradient: LinearGradient(colors: [
                                //   Color(0xff24262b),
                                //   bg,
                                //   Color(0xff36383d)
                                // ], stops: [
                                //   0.2,
                                //   0.5,
                                //   1,
                                // ], begin: Alignment.topLeft, end: Alignment.bottomRight, transform: GradientRotation(0.9)),
                              ),
                              child: Text('${index + 1}. ${inboxDB.inboxList[index]['title']}',
                                  style: TextStyle(
                                    color: txt,
                                    fontSize: 16,
                                  )),
                            )),
                      ))),
            ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Center(
          child: NeomorphismButton(
            action: _addTodoDialog,
            height: 40,
            width: 40,
            child: const Icon(Icons.add, color: brand),
          ),
        ),
      ),
    );
  }
}
