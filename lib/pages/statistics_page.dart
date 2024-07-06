import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/right_menu.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        endDrawer: RightMenu(thisPage: 'Dashboard'),
        appBar: MyAppBar(icon: Icons.add_chart, text: 'Dashboard'),
        body: Column(
          children: [],
        ));
  }
}
