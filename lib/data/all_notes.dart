import 'package:flutter/widgets.dart';

class AllNotes extends ChangeNotifier {
  List allNotes = [
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
    {
      'key': 2,
      'title': 'Заголовок',
      'desc': 'Любой текст',
      'date': '20 Jan 2024',
      'tag': 'tag',
      'pined': false,
    },
  ];

  void addNote(Map note) {
    allNotes.add(note);
    notifyListeners();
  }
}
