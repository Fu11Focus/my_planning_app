import 'package:flutter/material.dart';
import 'package:flutter_tests/pages/calendar_page.dart';
import 'package:flutter_tests/pages/habbits_tracker_page.dart';
import 'package:flutter_tests/pages/inbox_page.dart';
import 'package:flutter_tests/pages/notes_page.dart';
import 'package:flutter_tests/pages/projects_page.dart';
import 'package:flutter_tests/pages/settings_page.dart';
import 'package:flutter_tests/pages/statistics_page.dart';
import 'package:flutter_tests/pages/today_page.dart';
import 'pages/wish_board_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WishBoardPage(),
      routes: {
        '/wishboard': (context) => const WishBoardPage(),
        '/habbitsTracker': (context) => const HabittsTracker(),
        '/today': (context) => const Today(),
        '/calendar': (context) => const Calendar(),
        '/inbox': (context) => const Inbox(),
        '/notes': (context) => const Notes(),
        '/projects': (context) => const Projects(),
        '/statistics': (context) => const Statistics(),
        '/settings': (context) => const Settings(),
      },
    );
  }
}
