import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class HabitsDB extends ChangeNotifier {
  List habbitsList = [];
  final _myBox = Hive.box('HabitsBox');
//create database if this first time runing app
  void createInitialData() {
    habbitsList = [];
  }

//load the data from database
  void loadData() {
    habbitsList = _myBox.get('HABITS');
  }

//update the database
  void updateDataBase() {
    _myBox.put('HABITS', habbitsList);
  }

  void addHabit(String title, List<String> daysOfWeek, start, end) {
    Map<String, bool> progress = {};
    DateFormat dateFormat = DateFormat('dd MMM yyyy');
    for (DateTime date = start; date.isBefore(end) || dateFormat.format(date) == dateFormat.format(end); date = date.add(const Duration(days: 1))) {
      if (daysOfWeek.contains(DateFormat('EEE').format(date))) {
        progress[dateFormat.format(date)] = false;
      }
    }
    habbitsList.add({'id': const Uuid().v4(), 'title': title, 'daysOfWeek': daysOfWeek, 'progress': progress, 'start': start, 'finish': end});
    updateDataBase();
    notifyListeners();
  }

  void toDayIsDone(id, value, selectedDate) {
    int index = habbitsList.indexWhere((element) => element['id'] == id);
    habbitsList[index]['progress'][DateFormat('dd MMM yyyy').format(selectedDate)] = value;

    updateDataBase();
    notifyListeners();
  }

  void removeHabit(index) {
    habbitsList.removeAt(index);
    updateDataBase();
    notifyListeners();
  }
}
