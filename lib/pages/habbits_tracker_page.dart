import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/right_menu.dart';

class HabittsTracker extends StatelessWidget {
  const HabittsTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const RightMenu(thisPage: 'Habbits Tracker'),
      appBar: const MyAppBar(icon: Icons.task_alt_sharp, text: 'Habbits Tracker'),
      body: Center(
        child: Builder(builder: (context) {
          return GestureDetector(
            child: const Icon(Icons.add),
            onTap: () => showDialog(
                context: context,
                builder: (context) => Builder(
                    builder: (context) => Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.red),
                        ))),
          );
        }),
      ),
    );
  }
}
