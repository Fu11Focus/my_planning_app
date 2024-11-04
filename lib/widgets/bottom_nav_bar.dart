import 'package:flutter/material.dart';

import '../util/color_palette.dart';
import 'neomorphism_button.dart';

class BottomNavBar extends StatelessWidget {
  final VoidCallback action;
  const BottomNavBar({required this.action, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15, top: 10),
        child: Center(
          child: NeomorphismButton(
            action: action,
            height: 40,
            width: 40,
            child: const Icon(Icons.add, color: brand),
          ),
        ),
      ),
    );
  }
}
