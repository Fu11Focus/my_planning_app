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
  Map note = {
    'title': '',
    'desc': '',
    'date': '',
    'tag': '',
  };
  void changedTitle(value) {
    setState(() {
      note['title'] = value;
    });
  }

  void changedTag(value) {
    setState(() {
      note['tag'] = value;
    });
  }

  void changedDesc(value) {
    setState(() {
      note['desc'] = value;
    });
  }

  bool titleIs = true, tagIs = true, firstSave = true;
  @override
  Widget build(BuildContext context) {
    final dateOfCreation = DateFormat.yMMMd().format(DateTime.now());
    note['date'] = dateOfCreation;
    void addNote(data) {
      if (firstSave) {
        !firstSave;
        setState(() {
          titleIs = note['title'] != '';
          tagIs = note['tag'] != '';
        });
      }
      if (titleIs && tagIs) {
        Provider.of<AllNotes>(context, listen: false).addNote(data);
        Future.delayed(
            const Duration(milliseconds: 1000),
            () => showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Диалоговое окно не закроется при касании вне его
                  barrierColor: Colors.transparent,
                  builder: (BuildContext context) {
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.of(context)
                          .pop(true); // Закрыть диалоговое окно через 2 секунды
                    });

                    return Center(
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 2),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: shadowDark, // Цвет фона
                          borderRadius: BorderRadius.circular(10), // Форма
                        ),
                        child: const Text(
                          'Saved!',
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
      } else {
        setState(() {
          titleIs = note['title'] != '';
          tagIs = note['tag'] != '';
        });
      }
    }

    return Scaffold(
      body: Column(
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
            width: MediaQuery.of(context).size.width,
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
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(children: [
              //input for title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (value) => {
                    changedTitle(value),
                    setState(() {
                      titleIs = value.isNotEmpty;
                    })
                  },
                  style: const TextStyle(
                      color: txt,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: titleIs ? bg : Colors.red, width: 1)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: titleIs ? bg : Colors.red, width: 1)),
                      hintText: 'New note'),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: TextField(
                          onChanged: (value) => {
                            changedTag(value),
                            setState(() {
                              tagIs = value.isNotEmpty;
                            })
                          },
                          style:
                              const TextStyle(color: txt, letterSpacing: 1.5),
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: tagIs ? bg : Colors.red,
                                      width: 1)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: tagIs ? bg : Colors.red,
                                      width: 1)),
                              hintText: 'Tag for note',
                              contentPadding: const EdgeInsets.all(0)),
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
                        dateOfCreation,
                        style: const TextStyle(color: txt, letterSpacing: 1.5),
                      ),
                    ],
                  )
                ],
              )
            ]),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                color: bg,
                boxShadow: [
                  BoxShadow(
                      color: shadowLight, offset: Offset(0, -5), blurRadius: 5)
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: TextField(
                onChanged: (value) => {
                  changedDesc(value),
                },
                style: const TextStyle(color: txt, letterSpacing: 1.5),
                maxLines: null,
                decoration:
                    const InputDecoration(hintText: 'Write anything...'),
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //save button
            NeomorphismButton(
              height: 60,
              width: 60,
              action: () => addNote(note),
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
                  ]),
            ),
            //delete button
            NeomorphismButton(
              height: 60,
              width: 60,
              action: () => {},
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
                  ]),
            ),
          ],
        )
      ],
    );
  }
}
