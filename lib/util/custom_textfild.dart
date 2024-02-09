import 'package:flutter/material.dart';
import 'package:flutter_tests/util/color_palette.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final double marginTop, marginRight, marginBottom, marginLeft;
  const CustomTextField(
      {Key? key,
      required this.hintText,
      this.marginTop = 0,
      this.marginRight = 0,
      this.marginBottom = 0,
      this.marginLeft = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: marginTop,
          right: marginRight,
          bottom: marginBottom,
          left: marginLeft),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: shadowDark),
          BoxShadow(
            color: bg,
            spreadRadius: -5,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        style: const TextStyle(color: txt),
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    );
  }
}
