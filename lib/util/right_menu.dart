import 'package:flutter/material.dart';

class RightMenu extends StatelessWidget {
  final String thisPage;
  const RightMenu({Key? key, required this.thisPage}) : super(key: key);

  ListTile buildListTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon,
        color: thisPage == title
            ? const Color(0xff2fb9c9)
            : const Color(0xffccd0cf),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: thisPage == title
              ? const Color(0xff2fb9c9)
              : const Color(0xffccd0cf),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 150.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xff30343a),
            blurRadius: 18,
            offset: Offset(-18, -18),
          ),
          BoxShadow(
            color: Color.fromARGB(255, 33, 35, 39),
            blurRadius: 18,
            offset: Offset(18, 18),
          ),
        ],
        color: Color(0xff292d32),
      ),
      child: ListView(
        children: <Widget>[
          buildListTile(Icons.home, 'Whish Board'),
          buildListTile(Icons.person, 'Habbits Tracker'),
          buildListTile(Icons.calendar_today_rounded, 'Today'),
          buildListTile(Icons.calendar_month, 'Calendar'),
          buildListTile(Icons.add_box, 'Inbox'),
          buildListTile(Icons.note, 'Notes'),
          buildListTile(Icons.stairs, 'Projects'),
          buildListTile(Icons.access_time, 'Statistics'),
          buildListTile(Icons.settings, 'Settings'),
        ],
      ),
    );
  }
}
