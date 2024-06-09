import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class TodoList extends ChangeNotifier {
  List todoList = [];
  final _myBox = Hive.box('ToDoListBox');
//create database if this first time runing app
  void createInitialData() {
    todoList = [
      {'id': const Uuid().v4(), 'title': "Write your task for today", 'done': false, 'date': DateTime.now()},
      {'id': const Uuid().v4(), 'title': "Test", 'done': false, 'date': DateTime(2024, 5, 20)},
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

  void addTodoItem(String title, bool done, DateTime date) {
    todoList.add({'id': const Uuid().v4(), 'title': title, 'done': done, 'date': date});
    updateDataBase();
    notifyListeners();
  }

  void toDone(id, value) {
    int index = todoList.indexWhere((element) => element['id'] == id);
    todoList[index]['done'] = !todoList[index]['done'];
    updateDataBase();
    notifyListeners();
  }
}
