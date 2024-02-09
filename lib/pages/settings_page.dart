import 'package:flutter/material.dart';
import 'package:flutter_tests/util/my_appbar.dart';
import 'package:flutter_tests/util/right_menu.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      endDrawer: RightMenu(thisPage: 'Settings'),
      appBar: MyAppBar(icon: Icons.settings_outlined, text: "Settings"),
      body: Center(child: Text('Setup for app.')),
    );
  }
}
