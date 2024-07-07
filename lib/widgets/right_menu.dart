import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      padding: const EdgeInsets.all(0),
      width: 300,
      height: 1000,
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowLight,
            blurRadius: 5,
            offset: Offset(-5, -5),
          ),
          BoxShadow(
            color: shadowDark,
            blurRadius: 5,
            offset: Offset(5, 5),
          ),
        ],
        color: bg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 400,
            child: ListView(
              padding: const EdgeInsets.only(top: 20),
              children: <Widget>[
                buildListTile(Icons.sunny_snowing, 'Whish Board', '/wishboard'),
                buildListTile(Icons.sports_basketball, 'Habits', '/habbitsTracker'),
                buildListTile(Icons.calendar_month, 'Calendar', '/calendar'),
                buildListTile(Icons.inbox, 'Inbox', '/inbox'),
                buildListTile(Icons.create_rounded, 'Notes', '/notes'),
                // buildListTile(Icons.style, 'Projects', '/projects'),
                buildListTile(Icons.add_chart_outlined, 'Dashboard', '/statistics'),
                buildListTile(Icons.settings, 'Settings', '/settings'),
              ],
            ),
          ),
          const Text(
            'v1.0.0',
            style: TextStyle(color: hintTxt),
          ),
        ],
      ),
    );
  }
}
