import 'package:flutter/material.dart';
import 'package:flutter_tests/my_icons_icons.dart';
import 'package:flutter_tests/util/color_palette.dart';

class DelContainer extends StatelessWidget {
  final VoidCallback action;
  const DelContainer({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Delete',
            style: TextStyle(color: txt, fontSize: 18),
          ),
          Divider(
            indent: 10,
          ),
          Icon(
            MyIcons.trash,
            color: txt,
          )
        ],
      ),
    );
  }
}
