import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/del_container.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/right_menu.dart';
import 'package:popover/popover.dart';

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
            onTap: () {
              showPopover(
                context: context,
                bodyBuilder: (context) => Container(
                  width: 10,
                  height: 10,
                  color: Colors.cyan,
                  child: Center(
                    child: Text(
                      'Hello',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                onPop: () => print('Popover was popped!'),
                direction: PopoverDirection.bottom,
                backgroundColor: Colors.white,
                width: 200,
                height: 400,
                arrowHeight: 15,
                arrowWidth: 30,
              );
            },
          );
        }),
      ),
    );
  }
}
