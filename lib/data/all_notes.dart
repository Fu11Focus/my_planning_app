import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AllNotes extends ChangeNotifier {
  List allNotes = [];
  final _myBox = Hive.box('MyBox');
//create database if this first time runing app
  void createInitialData() {
    allNotes = [
      {
        'key': 0,
        'title': 'Новая заметка',
        'desc': 'Something text. bla-bla-bla',
        'date': '21 Oct 2023',
        'tag': 'hobby',
        'pined': true,
      },
      {
        'key': 1,
        'title': 'Привычки',
        'desc': 'бег, йога, вода, бросить курить',
        'date': '20 Feb 2024',
        'tag': 'Здоровье',
        'pined': false,
      },
    ];
  }

//load the data from database
  void loadData() {
    allNotes = _myBox.get('ALLNOTES');
  }

//update the database
  void updateDataBase() {
    _myBox.put('ALLNOTES', allNotes);
  }

  void addNote(Map note) {
    allNotes.add(note);
    updateDataBase();
    notifyListeners();
  }

  void pinedNote(int index) {
    allNotes[index]['pined'] = !allNotes[index]['pined'];
    updateDataBase();
    notifyListeners();
  }
}
