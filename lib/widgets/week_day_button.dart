import 'package:flutter/material.dart';
import 'package:flutter_tests/util/color_palette.dart';

class WeekDayButton extends StatefulWidget {
  final String dayOfWeek;
  final bool active;
  final VoidCallback onPress;

  const WeekDayButton({Key? key, required this.active, required this.dayOfWeek, required this.onPress}) : super(key: key);

  @override
  State<WeekDayButton> createState() => _WeekDayButtonState();
}

class _WeekDayButtonState extends State<WeekDayButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onPress,
        child: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(5),
            height: (MediaQuery.of(context).size.width * 0.8) / 7.5,
            width: (MediaQuery.of(context).size.width * 0.8) / 7.5,
            decoration: BoxDecoration(color: widget.active ? brand : shadowDark, borderRadius: BorderRadius.circular(100)),
            child: Center(
              child: Text(
                widget.dayOfWeek,
                style: TextStyle(
                  color: widget.active ? shadowDark : txt,
                  fontSize: ((MediaQuery.of(context).size.width * 0.8) / 7.5) / 3.46,
                ),
              ),
            )));
  }
}
