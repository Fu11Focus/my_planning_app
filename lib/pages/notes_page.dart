import 'package:flutter/material.dart';
import 'package:ToDoDude/data/all_notes.dart';
import 'package:ToDoDude/my_icons_icons.dart';
import 'package:ToDoDude/util/color_palette.dart';
import 'package:ToDoDude/widgets/custom_textfild.dart';
import 'package:ToDoDude/widgets/my_appbar.dart';
import 'package:ToDoDude/widgets/note_card.dart';
import 'package:ToDoDude/widgets/right_menu.dart';
import 'package:ToDoDude/widgets/tag.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../widgets/neomorphism_button.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final _myBox = Hive.box('MyBox');
  AllNotes dbNotes = AllNotes();

  List viewNotes = [];
  List allTags = [];
  Set tags = {};
  @override
  void initState() {
    super.initState();
    if (_myBox.get('ALLNOTES') == null) {
      dbNotes.createInitialData();
    } else {
      dbNotes.loadData();
    }
    viewNotes = dbNotes.allNotes;
    for (var element in viewNotes) {
      allTags.add(element['tag']);
    }
    allTags.toSet().forEach((element) {
      tags.add({'tag': element, 'active': false});
    });
  }

  void searchNote(String text) {
    setState(() {
      viewNotes = dbNotes.allNotes.where((note) => note['title'].toLowerCase().contains(text.toLowerCase()) || note['desc'].toLowerCase().contains(text.toLowerCase()) || note['tag'].toLowerCase().contains(text.toLowerCase())).toList();
    });
  }

  void deleteNote(int index) {
    dbNotes.allNotes.removeWhere((note) => note == viewNotes[index]);
    dbNotes.updateDataBase();
    setState(() => viewNotes = dbNotes.allNotes);
    _clearTags();
  }

  void _clearTags() {
    allTags.clear();
    tags.clear();
    for (var element in viewNotes) {
      allTags.add(element['tag']);
    }
    allTags.toSet().forEach((element) {
      tags.add({'tag': element, 'active': false});
    });
  }

  void tapOnTag(int index) {
    bool status = tags.elementAt(index)['active'];
    setState(() {
      tags.elementAt(index)['active'] = !status;
    });

    // Создаем список активных тегов
    List<String> activeTags = [];
    for (var tag in tags) {
      if (tag['active']) {
        activeTags.add(tag['tag']);
      }
    }

    // Фильтруем заметки на основе активных тегов
    setState(() {
      var num = 0;
      for (var tag in tags) {
        if (tag['active']) {
          num++;
        }
      }

      if (num == 0 || num == tags.length) {
        viewNotes = dbNotes.allNotes;
      } else {
        viewNotes = dbNotes.allNotes.where((note) => activeTags.contains(note['tag'])).toList();
      }
    });
  }

  void onPined(int index) {
    var i = dbNotes.allNotes.indexWhere((element) => element == viewNotes[index]);
    dbNotes.pinedNote(i);
    _filteredByUnpinedNotes();
    _filteredByPinedNotes();
    setState(() {
      viewNotes = dbNotes.allNotes;
      _clearTags();
    });
  }

  void _filteredByPinedNotes() {
    var pinnedNotes = [];
    var unpinnedNotes = [];
    for (var note in dbNotes.allNotes) {
      if (note['pined'] == true) {
        pinnedNotes.add(note);
      } else {
        unpinnedNotes.add(note);
      }
    }
    pinnedNotes.addAll(unpinnedNotes);
    dbNotes.allNotes = pinnedNotes;
    dbNotes.updateDataBase();
  }

  void _filteredByUnpinedNotes() {
    var pinnedNotes = [];
    var unpinnedNotes = [];
    for (var note in dbNotes.allNotes) {
      if (note['pined'] == true) {
        pinnedNotes.add(note);
      } else {
        unpinnedNotes.add(note);
      }
    }
    var temp;
    for (int i = 0; i < unpinnedNotes.length - 1; i++) {
      for (var j = 0; j < unpinnedNotes.length - 1 - i; j++) {
        var date1 = DateFormat('dd MMM yyyy').parse(unpinnedNotes[j]['date']);
        var date2 = DateFormat('dd MMM yyyy').parse(unpinnedNotes[j + 1]['date']);
        if (date1.isAfter(date2)) {
          temp = unpinnedNotes[j];
          unpinnedNotes[j] = unpinnedNotes[j + 1];
          unpinnedNotes[j + 1] = temp;
        }
      }
    }
    pinnedNotes.addAll(unpinnedNotes);
    dbNotes.allNotes = pinnedNotes;
    dbNotes.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => false,
      child: Scaffold(
        endDrawer: const RightMenu(thisPage: 'Notes'),
        appBar: const MyAppBar(icon: Icons.mode_edit_outlined, text: 'Notes'),
        body: Column(
          children: [
            CustomTextField(hintText: 'Search anything...', marginTop: 10, marginRight: 20, marginLeft: 20, onChange: searchNote),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: tags.length,
                        itemBuilder: (context, index) {
                          return Tag(text: tags.elementAt(index)['tag'], onTap: () => tapOnTag(index), active: tags.elementAt(index)['active']);
                        }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: viewNotes.isEmpty
                  ? const Center(
                      child: Text('Create ur first note. \nPress on "+".', style: TextStyle(color: hintTxt, fontSize: 20)),
                    )
                  : ListView.builder(
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
                                    () => onPined(index),
                                  )
                                },
                                icon: Icons.push_pin_outlined,
                                backgroundColor: bg,
                              ),
                              SlidableAction(
                                autoClose: true,
                                onPressed: (context) => deleteNote(index),
                                icon: MyIcons.trash,
                                backgroundColor: bg,
                              )
                            ]),
                            child: GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/createNote', arguments: {'key': viewNotes[index]['key'], 'pinPressed': () => onPined(index)}),
                                child: NoteCard(
                                  title: viewNotes[index]['title'],
                                  desc: viewNotes[index]['desc'],
                                  date: viewNotes[index]['date'],
                                  tag: viewNotes[index]['tag'],
                                  pined: viewNotes[index]['pined'],
                                )),
                          ),
                        );
                      }),
            )
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 80,
          child: Center(
            child: NeomorphismButton(
              action: () => Navigator.pushNamed(context, '/createNote'),
              height: 40,
              width: 40,
              child: const Icon(Icons.add, color: brand),
            ),
          ),
        ),
      ),
    );
  }
}
