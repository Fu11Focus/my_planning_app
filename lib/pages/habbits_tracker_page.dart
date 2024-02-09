import 'package:flutter/material.dart';
import 'package:flutter_tests/util/my_appbar.dart';
import 'package:flutter_tests/util/right_menu.dart';

class HabittsTracker extends StatelessWidget {
  const HabittsTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      endDrawer: RightMenu(thisPage: 'Habbits Tracker'),
      appBar: MyAppBar(icon: Icons.task_alt_sharp, text: 'Habbits Tracker'),
      body: Center(
          child: Text('Habbits Tracker',
              style: TextStyle(
                fontSize: 40,
                color: Color(0xffccd0cf),
              ))),
    );
  }
}
