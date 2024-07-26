import 'package:flutter/material.dart';
import 'package:ToDoDude/util/color_palette.dart';

class Tag extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const Tag({super.key, required this.text, required this.onTap, required this.active});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.only(right: 20),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: !active
              ? BoxDecoration(color: bg, borderRadius: const BorderRadius.all(Radius.elliptical(10, 15)), boxShadow: [BoxShadow(color: active ? bg : shadowDark, offset: const Offset(5, 5), blurRadius: 5), BoxShadow(color: active ? bg : shadowLight, offset: const Offset(-5, -5), blurRadius: 5)])
              : const BoxDecoration(
                  // color: bg,
                  borderRadius: BorderRadius.all(Radius.elliptical(10, 15)),
                  boxShadow: [
                    BoxShadow(color: shadowDark),
                    BoxShadow(
                      color: shadowLight,
                      spreadRadius: -5,
                      blurRadius: 10,
                    ),
                  ],
                ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: txt, letterSpacing: 1.5),
            ),
          )),
    );
  }
}
