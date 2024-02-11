import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/right_menu.dart';

class WishBoardPage extends StatelessWidget {
  const WishBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      endDrawer: RightMenu(thisPage: 'Whish Board'),
      appBar: MyAppBar(
        icon: Icons.sunny_snowing,
        text: 'Wish Board',
      ),
      body: Center(
          child: Text('Wish Board Page',
              style: TextStyle(
                fontSize: 40,
                color: Color(0xffccd0cf),
              ))),
    );
  }
}
