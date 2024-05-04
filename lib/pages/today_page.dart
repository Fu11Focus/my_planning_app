// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/right_menu.dart';

class Today extends StatelessWidget {
  const Today({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const RightMenu(thisPage: 'Today'),
        appBar: const MyAppBar(icon: Icons.calendar_today_outlined, text: 'Today'),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  CheckboxListTile(
                    value: false,
                    onChanged: null,
                    title: Text('Create my app'),
                    subtitle: Text('todo'),
                  ),
                  CheckboxListTile(
                    value: true,
                    onChanged: null,
                    title: Text('Workout'),
                    subtitle: Text('habbit'),
                  ),
                  CheckboxListTile(
                    value: true,
                    onChanged: null,
                    title: Text('Call Mom'),
                    subtitle: Text('todo'),
                  ),
                  CheckboxListTile(
                    value: false,
                    onChanged: null,
                    title: Text('Brakfast'),
                    subtitle: Text('todo'),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
