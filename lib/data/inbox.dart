import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class InboxList extends ChangeNotifier {
  List inboxList = [];
  final _myBox = Hive.box('InboxListBox');
//create database if this first time runing app
  void createInitialData() {
    inboxList = [
      {'id': const Uuid().v4(), 'title': 'Select date for to do for this task.'},
    ];
  }

//load the data from database
  void loadData() {
    inboxList = _myBox.get('INBOXLIST');
  }

//update the database
  void updateDataBase() {
    _myBox.put('INBOXLIST', inboxList);
  }

  void addNewItem(String title) {
    inboxList.add({
      'id': const Uuid().v4(),
      'title': title,
    });
    updateDataBase();
    notifyListeners();
  }

  void removeFromInbox(id) {
    int index = inboxList.indexWhere((element) => element['id'] == id);
    inboxList.removeAt(index);
    updateDataBase();
    notifyListeners();
  }
}
