import 'package:flutter/material.dart';
import 'package:flutter_tests/data/all_notes.dart';
import 'package:flutter_tests/util/color_palette.dart';
import 'package:flutter_tests/widgets/custom_textfild.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/note_card.dart';
import 'package:flutter_tests/widgets/right_menu.dart';
import 'package:flutter_tests/widgets/tag.dart';
import 'package:provider/provider.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    var allNotes = Provider.of<AllNotes>(context).allNotes;
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
              margin: const EdgeInsets.only(top: 10),
              height: 50,
              child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: allNotes.length,
                  itemBuilder: (context, index) {
                    return Tag(text: allNotes[index]['tag']);
                  })),
          Expanded(
              child: ListView.builder(
                  itemCount: allNotes.length,
                  itemBuilder: (context, index) {
                    return NoteCard(
                        title: allNotes[index]['title'],
                        text: allNotes[index]['desc'],
                        date: allNotes[index]['date'],
                        tag: allNotes[index]['tag']);
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: shadowDark,
        foregroundColor: brand,
        splashColor: shadowDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.add_outlined),
        onPressed: () {
          Navigator.pushNamed(context, '/createNote');
        },
      ),
    );
  }
}
