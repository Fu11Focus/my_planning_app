// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_tests/util/right_menu.dart';

class WishBoardPage extends StatelessWidget {
  const WishBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292d32),
      endDrawer: RightMenu(thisPage: 'Whish Board'),
      drawerScrimColor: Colors.transparent,
      appBar: AppBar(
        leading: Container(
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              'Wish Board 🔆',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xff2fb9c9),
              ),
            )),
        leadingWidth: 200,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: const Color(0xff2fb9c9), //change color on your need
        ),
        backgroundColor: Color(0xff292d32),
        elevation: 0,
      ),
      body: const Center(
          child: Text('Wish Board Page',
              style: TextStyle(
                fontSize: 40,
                color: Color(0xffccd0cf),
              ))),
    );
  }
}
