import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class TodoList extends ChangeNotifier {
  List todoList = [];
  final _myBox = Hive.box('ToDoListBox');
//create database if this first time runing app
  void createInitialData() {
    todoList = [
      {'title': "Write your task for today", 'type': 'todo', 'done': false, 'date': DateFormat('dd MMM yyyy').format(DateTime.now())},
      {'title': "Test", 'type': 'todo', 'done': false, 'date': '20 May 2024'},
    ];
  }

//load the data from database
  void loadData() {
    todoList = _myBox.get('TODOLIST');
  }

//update the database
  void updateDataBase() {
    _myBox.put('TODOLIST', todoList);
  }

  void addTodoItem(Map todoItem) {
    todoList.add(todoItem);
    updateDataBase();
    notifyListeners();
  }

  void toDone(int index) {
    todoList[index]['done'] = !todoList[index]['done'];
    updateDataBase();
    notifyListeners();
  }
}
