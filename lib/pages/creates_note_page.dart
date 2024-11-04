// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ToDoDude/data/all_notes.dart';
import 'package:ToDoDude/my_icons_icons.dart';
import 'package:ToDoDude/util/color_palette.dart';
import 'package:ToDoDude/widgets/neomorphism_button.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});
  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  late Map note;
  late int indexNote;
  late bool titleNotEmpty, tagNotEmpty;
  String date = DateFormat('dd MMM yyyy').format(DateTime.now());
  late TextEditingController _title;
  late TextEditingController _tag;
  late TextEditingController _desc;
  late bool firstBuild;
  late int keyNote;
  late bool pined;
  final _myBox = Hive.box('MyBox');
  AllNotes dbNotes = AllNotes();
  @override
  void initState() {
    super.initState();
    if (_myBox.get('ALLNOTES') == null) {
      dbNotes.createInitialData();
    } else {
      dbNotes.loadData();
    }
    indexNote = 0;
    firstBuild = true;
    _title = TextEditingController();
    _tag = TextEditingController();
    _desc = TextEditingController();
    keyNote = Random().hashCode;
    titleNotEmpty = true;
    tagNotEmpty = true;
    pined = false;
    note = {'title': '', 'tag': '', 'desc': '', 'date': date, 'key': keyNote, 'pined': pined};
  }

  void _updateFields() {
    if (firstBuild) {
      Map? arguments = ModalRoute.of(context)?.settings.arguments as Map?;
      if (arguments != null) {
        for (var element in dbNotes.allNotes) {
          if (element['key'] == arguments['key']) {
            note = element;
          }
        }
        _title.text = note['title'];
        _tag.text = note['tag'];
        _desc.text = note['desc'];
        date = note['date'];
        pined = note['pined'];
        keyNote = note['key'];
      } else {
        indexNote = -1;
      }
    }
    firstBuild = false;
  }

  void deleteNote(index) {
    if (index != -1) {
      dbNotes.allNotes.removeWhere((element) => element['key'] == keyNote);
      dbNotes.updateDataBase();
    }
    _showDialog('Deleted.');
    //ожидание показа диалогового окна перед закрытием страницы редактирования
    Future.delayed(
      const Duration(milliseconds: 2400),
      () => Navigator.pop(context),
    );
  }

  void onSave() {
    if (_title.text.isNotEmpty && _tag.text.isNotEmpty) {
      setState(() {
        note = {'title': _title.text, 'tag': _tag.text, 'desc': _desc.text, 'date': date, 'key': keyNote, 'pined': pined};
      });
      if (indexNote != -1) {
        var i = -1;
        for (var element in dbNotes.allNotes) {
          i = i + 1;
          if (element['key'] == keyNote) {
            break;
          }
        }
        dbNotes.allNotes[i] = note;
        dbNotes.updateDataBase();
      } else {
        dbNotes.addNote(note);
        dbNotes.updateDataBase();
      }
      _showDialog('Saved!');
    } else {
      setState(() {
        titleNotEmpty = _title.text.isNotEmpty;
        tagNotEmpty = _tag.text.isNotEmpty;
      });
    }
  }

  void _showDialog(String msg) {
    Future.delayed(
        const Duration(milliseconds: 1000),
        () => showDialog(
              barrierDismissible: false,
              context: context,
              barrierColor: Colors.transparent,
              builder: (BuildContext context) {
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.of(context).pop(true);
                });

                return Center(
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: shadowDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      msg,
                      style: TextStyle(
                        color: txt,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.5,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                );
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    _updateFields();
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 0) {
                FocusScope.of(context).unfocus();
              }
            },
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.15,
                    left: 20,
                    right: 20,
                    bottom: 0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/notes');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Close',
                          style: TextStyle(color: brand, fontSize: 24),
                        ),
                        Icon(
                          Icons.close,
                          color: brand,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: bg,
                    boxShadow: [
                      BoxShadow(
                        color: shadowDark,
                        offset: Offset(5, 5),
                        blurRadius: 5,
                      ),
                      BoxShadow(
                        color: shadowLight,
                        offset: Offset(-5, -5),
                        blurRadius: 5,
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _title,
                        onChanged: (value) => setState(() {
                          titleNotEmpty = value.isNotEmpty;
                        }),
                        style: const TextStyle(color: txt, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: titleNotEmpty ? bg : Colors.red, width: 1)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: titleNotEmpty ? bg : Colors.red, width: 1)),
                          hintText: 'New note',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                MyIcons.tag_1,
                                color: txt,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 45,
                                child: TextField(
                                  controller: _tag,
                                  onChanged: (value) => setState(() {
                                    tagNotEmpty = value.isNotEmpty;
                                  }),
                                  style: const TextStyle(color: txt, letterSpacing: 1.5),
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: tagNotEmpty ? bg : Colors.red, width: 1)),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: tagNotEmpty ? bg : Colors.red, width: 1)),
                                    hintText: 'Tag for note',
                                    contentPadding: const EdgeInsets.all(0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.date_range_outlined,
                                color: txt,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                note['date'],
                                style: const TextStyle(color: txt, letterSpacing: 1.5),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: 2,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: shadowLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: TextField(
                      controller: _desc,
                      enabled: true,
                      style: const TextStyle(color: txt, letterSpacing: 1.5),
                      maxLines: null,
                      decoration: const InputDecoration(hintText: 'Write anything...'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NeomorphismButton(
                  height: 60,
                  width: 60,
                  action: () => onSave(),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save_alt_outlined,
                        color: brand,
                      ),
                      Text(
                        'Save',
                        style: TextStyle(color: brand, letterSpacing: 1.5),
                      )
                    ],
                  ),
                ),
                NeomorphismButton(
                  height: 60,
                  width: 60,
                  action: () => deleteNote(keyNote),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        MyIcons.trash,
                        color: brand,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(color: brand, letterSpacing: 1.5),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
