import 'package:flutter/material.dart';
import 'package:flutter_tests/util/color_palette.dart';

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: txt, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              Icon(Icons.push_pin_outlined, color: pined ? hintTxt : bg),
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
