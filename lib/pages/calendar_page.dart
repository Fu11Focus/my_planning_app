import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/right_menu.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      endDrawer: RightMenu(thisPage: 'Calendar'),
      drawerScrimColor: Colors.transparent,
      appBar: MyAppBar(icon: Icons.calendar_month_outlined, text: 'Calendar'),
      body: Center(
          child: Text(
        'All ur tasks for month.',
      )),
    );
  }
}
