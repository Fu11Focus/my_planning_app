import 'package:flutter/material.dart';
import 'package:flutter_tests/data/all_notes.dart';
import 'package:flutter_tests/my_icons_icons.dart';
import 'package:flutter_tests/util/color_palette.dart';
import 'package:flutter_tests/widgets/neomorphism_button.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    var addNote = Provider.of<AllNotes>(context).addNote;
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
              TextField(
                onChanged: (value) => changedTitle(value),
                style: const TextStyle(
                    color: txt,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
                decoration: const InputDecoration(hintText: 'New note'),
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          onChanged: (value) => changedTag(value),
                          style:
                              const TextStyle(color: txt, letterSpacing: 1.5),
                          decoration: const InputDecoration(
                              hintText: 'Tag for note',
                              contentPadding: EdgeInsets.all(5)),
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Icon(
                          Icons.date_range_outlined,
                          color: txt,
                        ),
                      ),
                      Text(
                        '21 Oct 2023',
                        style: TextStyle(color: txt, letterSpacing: 1.5),
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
                onChanged: (value) => changedDesc(value),
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
          ],
        )
      ],
    );
  }
}
