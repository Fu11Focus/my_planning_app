import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/right_menu.dart';

class Inbox extends StatelessWidget {
  const Inbox({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      endDrawer: RightMenu(thisPage: 'Inbox'),
      appBar: MyAppBar(icon: Icons.inbox_outlined, text: 'Inbox'),
      body: Center(child: Text('Other tasks.')),
    );
  }
}
