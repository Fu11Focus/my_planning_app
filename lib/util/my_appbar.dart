import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final IconData icon;
  final double preferredHeight;

  const MyAppBar(
      {Key? key,
      required this.icon,
      required this.text,
      this.preferredHeight = 40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(
          margin: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Icon(icon),
              Container(
                width: 10,
              ),
              Text(
                text,
              ),
            ],
          )),
      automaticallyImplyLeading: false,
      leadingWidth: 200,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);
}
