// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_tests/util/color_palette.dart';
import 'package:flutter_tests/widgets/custom_textfild.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/note_card.dart';
import 'package:flutter_tests/widgets/right_menu.dart';
import 'package:flutter_tests/widgets/tag.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const RightMenu(thisPage: 'Notes'),
      appBar: const MyAppBar(icon: Icons.mode_edit_outlined, text: 'Notes'),
      body: Column(
        children: [
          const CustomTextField(
              hintText: 'Search anything...',
              marginTop: 10,
              marginRight: 20,
              marginLeft: 20),
          //строка с тегами
          Container(
              margin: EdgeInsets.only(top: 10),
              height: 50,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                scrollDirection: Axis.horizontal,
                children: [
                  Tag(text: 'Exemple'),
                  Tag(text: 'Exemple'),
                  Tag(text: 'Exemple'),
                  Tag(text: 'Exemple'),
                  Tag(text: 'Exemple'),
                ],
              )),
          Expanded(
            child: ListView(
              children: [
                NoteCard(
                  title: 'Note`s title',
                  text:
                      'Something descriptions. Один два три четыре пять шесть семь восемь девять десять одинадцать двенадцать тринадцать',
                  date: '21 Oct 2023',
                  tag: 'hobby',
                ),
                NoteCard(
                  title: 'Note`s title',
                  text: 'Something descriptions.',
                  date: '21 Oct 2023',
                  tag: 'hobby',
                ),
                NoteCard(
                  title: 'Note`s title',
                  text: 'Something descriptions.',
                  date: '21 Oct 2023',
                  tag: 'hobby',
                ),
                NoteCard(
                  title: 'Note`s title',
                  text: 'Something descriptions.',
                  date: '21 Oct 2023',
                  tag: 'hobby',
                ),
                NoteCard(
                  title: 'Note`s title',
                  text: 'Something descriptions.',
                  date: '21 Oct 2023',
                  tag: 'hobby',
                ),
                NoteCard(
                  title: 'Note`s title',
                  text: 'Something descriptions.',
                  date: '21 Oct 2023',
                  tag: 'hobby',
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: shadowDark,
        foregroundColor: brand,
        splashColor: shadowDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(Icons.add_outlined),
        onPressed: () {
          Navigator.pushNamed(context, '/createNote');
        },
      ),
    );
  }
}
