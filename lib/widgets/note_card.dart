import 'package:flutter/material.dart';
import 'package:ToDoDude/util/color_palette.dart';

class NoteCard extends StatelessWidget {
  final String title, desc, date, tag;
  final bool pined;
  const NoteCard({
    super.key,
    required this.title,
    required this.desc,
    required this.date,
    required this.tag,
    required this.pined,
  });

  @override
  Widget build(BuildContext context) {
    var customText = desc;
    if (desc.contains('\n')) {
      customText = '${desc.substring(0, desc.indexOf('\n'))}...';
    } else if (desc.length > 90) {
      customText = '${desc.substring(0, (desc.length - (desc.length - 90)))}...';
    }
    return GestureDetector(
      child: Container(
        height: 135,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
            // color: bg,
            gradient: LinearGradient(colors: [
              Color(0xff24262b),
              bg,
              Color(0xff36383d)
            ], stops: [
              0.2,
              0.5,
              1,
            ], transform: GradientRotation(0.9), begin: Alignment.topLeft, end: Alignment.bottomRight),
            /* border: Border.all(
              color: shadowLight,
            ),*/
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: shadowDark,
                offset: Offset(5, 5),
                blurRadius: 10,
              ),
              BoxShadow(
                color: shadowLight,
                offset: Offset(-5, -5),
                blurRadius: 10,
              )
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: txt, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              Icon(Icons.push_pin_outlined, color: pined ? hintTxt : Colors.transparent),
            ],
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
                decoration: const BoxDecoration(color: shadowDark, borderRadius: BorderRadius.all(Radius.circular(8))),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
      ),
    );
  }
}
