// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_tests/data/all_notes.dart';
import 'package:flutter_tests/my_icons_icons.dart';
import 'package:flutter_tests/util/color_palette.dart';
import 'package:flutter_tests/widgets/neomorphism_button.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    super.initState();
    firstBuild = true;
    _title = TextEditingController();
    _tag = TextEditingController();
    _desc = TextEditingController();
    titleNotEmpty = true;
    tagNotEmpty = true;
    note = {
      'title': '',
      'tag': '',
      'desc': '',
      'date': date,
    };
  }

  void _updateFields() {
    if (firstBuild) {
      Map? arguments = ModalRoute.of(context)?.settings.arguments as Map?;
      if (arguments != null) {
        indexNote = arguments['index'];
        note = Provider.of<AllNotes>(context).allNotes[indexNote];
        _title.text = note['title'];
        _tag.text = note['tag'];
        _desc.text = note['desc'];
        date = note['date'];
      } else {
        indexNote = -1;
      }
    }
    firstBuild = false;
  }

  void deleteNote(index) {
    if (index != -1) {
      Provider.of<AllNotes>(context, listen: false).allNotes.removeAt(index);
    }
    _showDialog('Deleted.');
    //ожидание показа диалогового окна перед закрытием страницы редактирования
    Future.delayed(
      const Duration(milliseconds: 2400),
      () => Navigator.pushNamed(context, '/notes'),
    );
  }

  void onSave() {
    if (_title.text.isNotEmpty && _tag.text.isNotEmpty) {
      setState(() {
        note = {'title': _title.text, 'tag': _tag.text, 'desc': _desc.text, 'date': date, 'pined': false};
      });
      if (indexNote != -1) {
        Provider.of<AllNotes>(context, listen: false).allNotes[indexNote] = note;
      } else {
        Provider.of<AllNotes>(context, listen: false).allNotes.add(note);
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              MyIcons.tag_2,
                              color: txt,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 60,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                            const Padding(
                              padding: EdgeInsets.only(right: 5.0),
                              child: Icon(
                                Icons.date_range_outlined,
                                color: txt,
                              ),
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: bg,
                    boxShadow: [BoxShadow(color: shadowLight, offset: Offset(0, -5), blurRadius: 5)],
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
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
        persistentFooterButtons: [
          Row(
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
                action: () => {},
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.push_pin_outlined,
                      color: brand,
                    ),
                    Text(
                      'Pin',
                      style: TextStyle(color: brand, letterSpacing: 1.5),
                    )
                  ],
                ),
              ),
              NeomorphismButton(
                height: 60,
                width: 60,
                action: () => deleteNote(indexNote),
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
          )
        ],
      ),
    );
  }
}
