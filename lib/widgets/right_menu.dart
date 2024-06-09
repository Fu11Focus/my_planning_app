import 'package:flutter/material.dart';
import 'package:flutter_tests/util/color_palette.dart';

class RightMenu extends StatelessWidget {
  final String thisPage;
  const RightMenu({Key? key, required this.thisPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListTile buildListTile(IconData icon, String title, String goTo) {
      return ListTile(
        onTap: () {
          Navigator.pushNamed(context, goTo);
        },
        leading: Icon(
          icon,
          color: thisPage == title ? brand : txt,
        ),
        title: Text(
          title,
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 16,
            color: thisPage == title ? brand : txt,
          ),
        ),
      );
    }

    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 50.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowLight,
            blurRadius: 18,
            offset: Offset(-18, -18),
          ),
          BoxShadow(
            color: shadowDark,
            blurRadius: 18,
            offset: Offset(18, 18),
          ),
        ],
        color: bg,
      ),
      child: ListView(
        children: <Widget>[
          buildListTile(Icons.home, 'Whish Board', '/wishboard'),
          buildListTile(Icons.task_sharp, 'Habbits Tracker', '/habbitsTracker'),
          buildListTile(Icons.calendar_month, 'Calendar', '/calendar'),
          buildListTile(Icons.inbox, 'Inbox', '/inbox'),
          buildListTile(Icons.create_rounded, 'Notes', '/notes'),
          buildListTile(Icons.style, 'Projects', '/projects'),
          buildListTile(Icons.airline_stops, 'Statistics', '/statistics'),
          buildListTile(Icons.settings, 'Settings', '/settings'),
        ],
      ),
    );
  }
}
