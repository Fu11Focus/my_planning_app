import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class TodoList extends ChangeNotifier {
  List todoList = [];
  final _myBox = Hive.box('ToDoListBox');
//create database if this first time runing app
  void createInitialData() {
    todoList = [
      {'id': const Uuid().v4(), 'title': "Write your task for today", 'done': false, 'date': DateTime.now(), 'notificationId': null},
      {'id': const Uuid().v4(), 'title': "Test", 'done': false, 'date': DateTime(2024, 5, 20), 'notificationId': null},
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

  void deleteToDoItem(id) {
    int index = todoList.indexWhere((element) => element['id'] == id);

    if (todoList[index]['notificationId'] != null) {
      AwesomeNotifications().cancel(todoList[index]['notificationId']);
    }
    todoList.removeAt(index);
    updateDataBase();
    notifyListeners();
  }

  void addTodoItem(String title, bool done, DateTime date, DateTime? notification, int? notificationId) {
    todoList.add({'id': const Uuid().v4(), 'title': title, 'done': done, 'date': date, 'notification': notification, 'notificationId': notificationId});
    if (notificationId != null) {
      AwesomeNotifications().createNotification(content: NotificationContent(id: notificationId, channelKey: "basic_channel", title: "ToDoDude", body: title), schedule: NotificationCalendar(year: notification!.year, month: notification.month, day: notification.day, hour: notification.hour, minute: notification.minute));
    }
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
