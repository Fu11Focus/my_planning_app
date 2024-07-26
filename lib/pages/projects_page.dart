import 'package:flutter/material.dart';
import 'package:ToDoDude/util/color_palette.dart';
import 'package:ToDoDude/widgets/my_appbar.dart';
import 'package:ToDoDude/widgets/right_menu.dart';

class Projects extends StatelessWidget {
  const Projects({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const RightMenu(thisPage: 'Projects'),
        appBar: const MyAppBar(icon: Icons.style_outlined, text: 'Projects'),
        body: Column(
          children: [
            Expanded(
              child: ListView(children: const [
                // SprintCard(status: 'in progress', start: '01.05.2024', finish: '24.07.2024', img: 'assets/imgs/xbox_gamepad.jpg'),
                // SprintCard(status: 'Archive', start: '01.05.2024', finish: '24.07.2024', img: 'assets/imgs/xbox_gamepad.jpg'),
              ]),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: brand,
          foregroundColor: shadowDark,
          onPressed: () => Navigator.pushNamed(context, '/projectCreate'),
          child: const Icon(
            Icons.add,
          ),
        ));
  }
}
