import 'package:flutter/material.dart';
import 'package:ToDoDude/data/all_notes.dart';
import 'package:ToDoDude/data/start_using_app.dart';
import 'package:ToDoDude/pages/calendar_page.dart';
import 'package:ToDoDude/pages/creates_note_page.dart';
import 'package:ToDoDude/pages/habbits_tracker_page.dart';
import 'package:ToDoDude/pages/habit_dashboard.dart';
import 'package:ToDoDude/pages/inbox_page.dart';
import 'package:ToDoDude/pages/notes_page.dart';
import 'package:ToDoDude/pages/project_create_page.dart';
import 'package:ToDoDude/pages/projects_page.dart';
import 'package:ToDoDude/pages/settings_page.dart';
import 'package:ToDoDude/pages/statistics_page.dart';
import 'package:ToDoDude/util/main_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'pages/wish_board_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('StartUsingAppBox');
  await Hive.openBox('MyBox');
  await Hive.openBox('WishBox');
  await Hive.openBox('ToDoListBox');
  await Hive.openBox('HabitsBox');
  await Hive.openBox('InboxListBox');

  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (context) => AllNotes())], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _myBox = Hive.box('StartUsingAppBox');
    StartApp startApp = StartApp();
    if (_myBox.get('STARTAPP') == null) {
      startApp.createInitialData();
    } else {
      startApp.loadData();
    }
    return MaterialApp(
      theme: mainTheme(),
      debugShowCheckedModeBanner: false,
      home: const WishBoardPage(),
      routes: {
        '/wishboard': (context) => const WishBoardPage(),
        '/habbitsTracker': (context) => const HabitsTracker(),
        '/calendar': (context) => const Calendar(),
        '/inbox': (context) => const Inbox(),
        '/notes': (context) => const Notes(),
        '/projects': (context) => const Projects(),
        '/statistics': (context) => Statistics(),
        '/settings': (context) => const Settings(),
        '/createNote': (context) => const CreateNotePage(),
        '/projectCreate': (context) => const ProjectCreate(),
        '/habitDashboard': (context) => const HabitDashboard(),
      },
    );
  }
}
