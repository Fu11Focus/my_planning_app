import 'package:flutter/material.dart';
import 'package:flutter_tests/util/right_menu.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff292d32),
      endDrawer: const RightMenu(thisPage: 'Notes'),
      drawerScrimColor: Colors.transparent,
      appBar: AppBar(
        leading: Container(
            margin: const EdgeInsets.only(left: 20, top: 15),
            child: Row(
              children: [
                const Icon(
                  Icons.edit_outlined,
                  color: Color(0xff2fb9c9),
                ),
                Container(
                  width: 10,
                ),
                const Text(
                  'Notes',
                  style: TextStyle(color: Color(0xff2fb9c9), fontSize: 24),
                )
              ],
            )),
        leadingWidth: 200,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Color(0xff2fb9c9), //change color on your need
        ),
        backgroundColor: const Color(0xff292d32),
        elevation: 0,
      ),
      body: Column(children: [
        Container(
          margin: const EdgeInsets.all(20),
          height: 40,
          decoration: BoxDecoration(
              color: const Color(0xff2a2d32),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Color(0xff1d1f21),
                    offset: Offset(8, 8),
                    blurRadius: 10),
                BoxShadow(
                    color: Color(0xff30343a),
                    offset: Offset(-8, -8),
                    blurRadius: 10),
              ]),
          child: const TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                hintText: 'Search something',
                hintStyle: TextStyle(color: Color.fromARGB(255, 139, 140, 140)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
          ),
        ),
        SizedBox(
            height: 60,
            child: ListView(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff2a2d32),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xff1d1f21),
                            offset: Offset(8, 8),
                            blurRadius: 10),
                        BoxShadow(
                            color: Color(0xff30343a),
                            offset: Offset(-8, -8),
                            blurRadius: 10),
                      ]),
                  margin: const EdgeInsets.only(left: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: const Text(
                    'Exemple 2',
                    style: TextStyle(color: Color(0xffccd0cf)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff2a2d32),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xff1d1f21),
                            offset: Offset(8, 8),
                            blurRadius: 10),
                        BoxShadow(
                            color: Color(0xff30343a),
                            offset: Offset(-8, -8),
                            blurRadius: 10),
                      ]),
                  margin: const EdgeInsets.only(left: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: const Text(
                    'Exemple 2',
                    style: TextStyle(color: Color(0xffccd0cf)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff2a2d32),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xff1d1f21),
                            offset: Offset(8, 8),
                            blurRadius: 10),
                        BoxShadow(
                            color: Color(0xff30343a),
                            offset: Offset(-8, -8),
                            blurRadius: 10),
                      ]),
                  margin: const EdgeInsets.only(left: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: const Text(
                    'Exemple 2',
                    style: TextStyle(color: Color(0xffccd0cf)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff2a2d32),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xff1d1f21),
                            offset: Offset(8, 8),
                            blurRadius: 10),
                        BoxShadow(
                            color: Color(0xff30343a),
                            offset: Offset(-8, -8),
                            blurRadius: 10),
                      ]),
                  margin: const EdgeInsets.only(left: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: const Text(
                    'Exemple 2',
                    style: TextStyle(color: Color(0xffccd0cf)),
                  ),
                ),
              ],
            )),
      ]),
    );
  }
}
