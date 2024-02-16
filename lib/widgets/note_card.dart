import 'package:flutter/material.dart';
import 'package:flutter_tests/util/color_palette.dart';

class NoteCard extends StatelessWidget {
  final String title, text, date, tag;
  const NoteCard({
    super.key,
    required this.title,
    required this.text,
    required this.date,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    var customText = text;
    if (text.contains('\n')) {
      customText = '${text.substring(0, text.indexOf('\n'))}...';
    } else if (text.length > 90) {
      customText =
          '${text.substring(0, (text.length - (text.length - 90)))}...';
    }
    return Container(
      height: 135,
      padding: const EdgeInsets.all(20),
      // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: bg,
          border: Border.all(
            color: shadowLight,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: const [
            BoxShadow(
              color: shadowDark,
              offset: Offset(-5, 5),
              blurRadius: 10,
            ),
            BoxShadow(
              color: shadowDark,
              offset: Offset(5, 5),
              blurRadius: 10,
            )
          ]),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: txt, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            Text(
              customText,
              style: const TextStyle(color: txt, letterSpacing: 1.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  date,
                  style: const TextStyle(color: txt, letterSpacing: 1.5),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: shadowDark,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Center(
                    child: Text(
                      tag,
                      style: const TextStyle(color: txt, letterSpacing: 1.5),
                    ),
                  ),
                )
              ],
            )
          ]),
    );
  }
}
