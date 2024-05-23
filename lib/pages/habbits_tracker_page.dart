import 'package:flutter/material.dart';
import 'package:flutter_tests/util/color_palette.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/right_menu.dart';

class HabittsTracker extends StatelessWidget {
  const HabittsTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const RightMenu(thisPage: 'Habbits Tracker'),
        appBar: const MyAppBar(icon: Icons.task_alt_sharp, text: 'Habbits Tracker'),
        body: ListView.builder(
          itemBuilder: ((context, index) => Container()),
        ));
  }
}
