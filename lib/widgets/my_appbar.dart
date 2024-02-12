import 'package:flutter/material.dart';
import 'package:flutter_tests/my_icons_icons.dart';

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
      actions: [
        Builder(
          builder: (context) => IconButton(
            padding: const EdgeInsets.only(right: 20),
            icon: const Icon(MyIcons.sandwich, size: 14),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
      ],
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
      leadingWidth: 300,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);
}
