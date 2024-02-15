import 'package:flutter/material.dart';
import 'package:flutter_tests/util/color_palette.dart';

class Tag extends StatelessWidget {
  final String text;
  const Tag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: const BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.all(Radius.elliptical(10, 15)),
            boxShadow: [
              BoxShadow(color: shadowDark, offset: Offset(5, 5), blurRadius: 5),
              BoxShadow(
                  color: shadowLight, offset: Offset(-5, -5), blurRadius: 5)
            ]),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: txt, letterSpacing: 1.5),
          ),
        ));
  }
}
