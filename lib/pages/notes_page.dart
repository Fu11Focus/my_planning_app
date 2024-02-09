import 'package:flutter/material.dart';
import 'package:flutter_tests/util/custom_textfild.dart';
import 'package:flutter_tests/util/my_appbar.dart';
import 'package:flutter_tests/util/right_menu.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        endDrawer: RightMenu(thisPage: 'Notes'),
        appBar: MyAppBar(icon: Icons.mode_edit_outlined, text: 'Notes'),
        body: Column(
          children: [
            CustomTextField(
                hintText: 'Search anything...',
                marginTop: 10,
                marginRight: 20,
                marginBottom: 10,
                marginLeft: 20),
          ],
        ));
  }
}
