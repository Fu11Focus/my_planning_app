// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_tests/data/todo_list.dart';
import 'package:flutter_tests/util/color_palette.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/right_menu.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  final _myBox = Hive.box('ToDoListBox');
  TodoList db = TodoList();
  List tasks = [];
  TextEditingController newTaskController = TextEditingController();
  @override
  void initState() {
    if (_myBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    updateTaskList();
    super.initState();
  }

  void updateTaskList() {
    tasks = db.todoList.where((element) => element['date'] == DateFormat('dd MMM yyyy').format(DateTime.now()) || element['done'] == false).toList(); //создаём новый лист из тасков, которые должны быть выполнены сегодня или не были выполнены в предыдущие дни
  }

  void addTodo() {
    if (newTaskController.text.isNotEmpty) {
      setState(() {
        db.addTodoItem({'title': newTaskController.text, 'done': false, 'date': DateFormat('dd MMM yyyy').format(DateTime.now())});
        updateTaskList();
      });
      Navigator.pop(context);
      newTaskController.text = '';
    }
  }

  void addTodoDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              actionsPadding: const EdgeInsets.all(0),
              insetPadding: const EdgeInsets.only(top: 10, bottom: 300, left: 20, right: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.all(0),
              contentTextStyle: const TextStyle(color: txt),
              backgroundColor: bg,
              elevation: 0,
              content: TextField(
                controller: newTaskController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter a task',
                ),
                style: TextStyle(color: txt),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: addTodo,
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                    child: Text(
                      'Add',
                      style: TextStyle(color: brand, fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () => {Navigator.pop(context), newTaskController.text = ''},
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: txt, fontSize: 20),
                    ),
                  ),
                )
              ],
            ));
  }

  //функия изменения статуса выполнено\не выполнено для задачи
  void toDone(index, done) {
    int indexTask = db.todoList.indexWhere((element) => element == tasks[index]); //получаем индекс нужной таски в базе данных
    db.toDone(indexTask);
    setState(() {
      updateTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const RightMenu(thisPage: 'Today'),
      appBar: const MyAppBar(icon: Icons.calendar_today_outlined, text: 'Today'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) => CheckboxListTile(
                value: tasks[index]['done'],
                onChanged: (checked) => toDone(index, checked),
                title: Text(tasks[index]['date'] == DateFormat('dd MMM yyyy').format(DateTime.now()) ? tasks[index]['title'] : '${tasks[index]['title']}(${tasks[index]['date']})', style: TextStyle(color: tasks[index]['done'] ? hintTxt : (tasks[index]['date'] == DateFormat('dd MMM yyyy').format(DateTime.now()) ? txt : Colors.red[300]), fontWeight: FontWeight.bold, decorationColor: hintTxt, decoration: tasks[index]['done'] ? TextDecoration.lineThrough : TextDecoration.none)),
                subtitle: Text(tasks[index]['type'], style: TextStyle(color: tasks[index]['done'] ? hintTxt : txt)),
                overlayColor: MaterialStatePropertyAll(brand),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodoDialog,
        backgroundColor: brand,
        child: Icon(
          Icons.add,
          size: 20,
        ),
      ),
    );
  }
}
