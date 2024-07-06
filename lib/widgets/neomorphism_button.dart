import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tests/util/color_palette.dart';

class NeomorphismButton extends StatefulWidget {
  final VoidCallback action;
  final double height, width;
  final Widget child;
  const NeomorphismButton({
    Key? key,
    required this.action,
    required this.child,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  State<NeomorphismButton> createState() => _NeomorphismButtonState();
}

class _NeomorphismButtonState extends State<NeomorphismButton> {
  double _offset = 5;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _offset = 0;
        });
      },
      onTapUp: (details) {
        setState(() {
          _offset = 5;
        });
        Future.delayed(const Duration(milliseconds: 100), widget.action);
      },
      onTapCancel: () {
        setState(() {
          _offset = 5;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        decoration: widget.width == widget.height
            ? BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color(0xff24262b),
                  Color(0xff36383d)
                ], stops: [
                  0.4,
                  1,
                ], begin: Alignment.topLeft, end: Alignment.bottomRight, transform: GradientRotation(0.7)),
                borderRadius: BorderRadius.circular(10),
                color: bg,
                boxShadow: [
                    BoxShadow(
                      color: shadowDark,
                      blurRadius: 5,
                      offset: Offset(_offset, _offset),
                    ),
                    BoxShadow(
                      color: shadowLight,
                      blurRadius: 5,
                      offset: Offset(-_offset, -_offset),
                    ),
                  ])
            : BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color(0xff24262b),
                  Color(0xff36383d)
                ], stops: [
                  0.2,
                  1,
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                color: bg,
                /*border: Border.all(color: shadowLight, width: 1),*/ borderRadius: BorderRadius.circular(10),
                boxShadow: [
                    BoxShadow(
                      color: shadowDark,
                      blurRadius: 5,
                      offset: Offset(_offset, _offset),
                    ),
                    BoxShadow(
                      color: shadowLight,
                      blurRadius: 5,
                      offset: Offset(-_offset, -_offset),
                    )
                  ]),
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
