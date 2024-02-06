import 'package:flutter/material.dart';
import 'package:flutter_tests/util/right_menu.dart';

class Inbox extends StatelessWidget {
  const Inbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff292d32),
      endDrawer: const RightMenu(thisPage: 'Inbox'),
      drawerScrimColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Color(0xff2fb9c9), //change color on your need
        ),
        backgroundColor: const Color(0xff292d32),
        elevation: 0,
        title: const Text(
          'Inbox',
          style: TextStyle(
            color: Color(0xffccd0cf),
          ),
        ),
      ),
      body: const Center(
          child: Text('Other tasks.',
              style: TextStyle(
                fontSize: 40,
                color: Color(0xffccd0cf),
              ))),
    );
  }
}
