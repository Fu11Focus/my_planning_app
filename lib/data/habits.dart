import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class HabitsDB extends ChangeNotifier {
  List habbitsList = [];
  final _myBox = Hive.box('HabitsBox');
//create database if this first time runing app
  void createInitialData() {
    habbitsList = [
      {
        'id': const Uuid().v4(),
        'title': 'Running',
        'daysOfWeek': ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        'progress': {'28 May 2024': true, '29 May 2024': false}
      },
      {
        'id': const Uuid().v4(),
        'title': 'Reading',
        'daysOfWeek': ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        'progress': {}
      },
      {
        'id': const Uuid().v4(),
        'title': 'Workout',
        'daysOfWeek': [
          'Mon',
          'Wed',
          'Fri',
        ],
        'progress': {}
      },
    ];
  }

//load the data from database
  void loadData() {
    habbitsList = _myBox.get('HABITS');
  }

//update the database
  void updateDataBase() {
    _myBox.put('HABITS', habbitsList);
  }

  void addHabit(
    String title,
    List<String> daysOfWeek,
  ) {
    habbitsList.add({'id': const Uuid().v4(), 'title': title, 'daysOfWeek': daysOfWeek, 'progress': {}});
    updateDataBase();
    notifyListeners();
  }

  void toDayIsDone(id, value, selectedDate) {
    print(DateFormat('dd MMM yyyy').format(selectedDate) + value.toString());
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
