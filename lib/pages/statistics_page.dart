import 'package:flutter/material.dart';
import 'package:flutter_tests/util/my_appbar.dart';
import 'package:flutter_tests/util/right_menu.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      endDrawer: RightMenu(thisPage: 'Statistics'),
      appBar: MyAppBar(icon: Icons.airline_stops, text: 'Statistics'),
      body: Center(child: Text('Check ur results.')),
    );
  }
}
