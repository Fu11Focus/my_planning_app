import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/right_menu.dart';

class Today extends StatelessWidget {
  const Today({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        endDrawer: RightMenu(thisPage: 'Today'),
        appBar: MyAppBar(icon: Icons.calendar_today_outlined, text: 'Today'),
        body: Center(
          child: Text('Today plan. Do it!!!'),
        ));
  }
}
