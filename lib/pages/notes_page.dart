import 'package:flutter/material.dart';
import 'package:flutter_tests/data/all_notes.dart';
import 'package:flutter_tests/my_icons_icons.dart';
import 'package:flutter_tests/util/color_palette.dart';
import 'package:flutter_tests/widgets/custom_textfild.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/note_card.dart';
import 'package:flutter_tests/widgets/right_menu.dart';
import 'package:flutter_tests/widgets/tag.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List viewNotes = [];
  @override
  void didChangeDependencies() {
    viewNotes = Provider.of<AllNotes>(context).allNotes;
    super.didChangeDependencies();
  }

  void searchNote(String text) {
    List filteredNotes = [];
    Provider.of<AllNotes>(context, listen: false).allNotes.forEach((element) {
      if (element['title'].toLowerCase().contains(text.toLowerCase()) || element['desc'].toLowerCase().contains(text.toLowerCase()) || element['tag'].toLowerCase().contains(text.toLowerCase())) {
        filteredNotes.add(element);
      }
    });
    setState(() {
      viewNotes = filteredNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        endDrawer: const RightMenu(thisPage: 'Notes'),
        appBar: const MyAppBar(icon: Icons.mode_edit_outlined, text: 'Notes'),
        body: Column(
          children: [
            CustomTextField(hintText: 'Search anything...', marginTop: 10, marginRight: 20, marginLeft: 20, onChange: searchNote),
            //строка с тегами
            Container(
                margin: const EdgeInsets.only(top: 10),
                height: 50,
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: viewNotes.length,
                    itemBuilder: (context, index) {
                      return Tag(text: viewNotes[index]['tag']);
                    })),
            Expanded(
                child: ListView.builder(
                    itemCount: viewNotes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Slidable(
                          endActionPane: ActionPane(motion: const StretchMotion(), children: [
                            SlidableAction(
                              autoClose: true,
                              onPressed: (context) => {
                                setState(
                                  () => viewNotes.removeAt(index),
                                )
                              },
                              icon: MyIcons.trash,
                              backgroundColor: bg,
                            )
                          ]),
                          child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/createNote', arguments: {'index': index}),
                              child: NoteCard(
                                title: viewNotes[index]['title'],
                                desc: viewNotes[index]['desc'],
                                date: viewNotes[index]['date'],
                                tag: viewNotes[index]['tag'],
                                pined: viewNotes[index]['pined'],
                              )),
                        ),
                      );
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
      ),
    );
  }
}
