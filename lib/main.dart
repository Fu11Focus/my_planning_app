import 'package:flutter/material.dart';
import 'package:flutter_tests/data/all_notes.dart';
import 'package:flutter_tests/pages/calendar_page.dart';
import 'package:flutter_tests/pages/creates_note_page.dart';
import 'package:flutter_tests/pages/habbits_tracker_page.dart';
import 'package:flutter_tests/pages/inbox_page.dart';
import 'package:flutter_tests/pages/notes_page.dart';
import 'package:flutter_tests/pages/project_create_page.dart';
import 'package:flutter_tests/pages/projects_page.dart';
import 'package:flutter_tests/pages/settings_page.dart';
import 'package:flutter_tests/pages/statistics_page.dart';
import 'package:flutter_tests/util/main_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'pages/wish_board_page.dart';

void main() async {
  await Hive.initFlutter();
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
        '/statistics': (context) => const Statistics(),
        '/settings': (context) => const Settings(),
        '/createNote': (context) => const CreateNotePage(),
        '/projectCreate': (context) => const ProjectCreate(),
      },
    );
  }
}
