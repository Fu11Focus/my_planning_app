import 'package:flutter/material.dart';

import '../util/color_palette.dart';

class NeoContainer extends StatelessWidget {
  final Widget child;
  const NeoContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color(0xff24262b),
            Color(0xff36383d)
          ], stops: [
            0.4,
            1,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight, transform: GradientRotation(0.9)),
          borderRadius: BorderRadius.circular(12),
          /*border: Border.all(color: shadowLight),*/ boxShadow: const [BoxShadow(color: shadowDark, offset: Offset(5, 5), blurRadius: 10), BoxShadow(color: shadowLight, offset: Offset(-5, -5), blurRadius: 10)]),
      child: child,
    );
  }
}
