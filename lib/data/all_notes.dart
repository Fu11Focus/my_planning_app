import 'package:flutter/widgets.dart';

class AllNotes extends ChangeNotifier {
  List allNotes = [
    {
      'key': 0,
      'title': 'Новая заметка',
      'desc': 'Something text. bla-bla-bla',
      'date': '21 Oct 2023',
      'tag': 'hobby'
    },
    {
      'key': 1,
      'title': 'Привычки',
      'desc': 'бег, йога, вода, бросить курить',
      'date': '20 Feb 2024',
      'tag': 'Здоровье'
    },
  ];

  void addNote(Map note) {
    allNotes.add(note);
    notifyListeners();
  }
}
