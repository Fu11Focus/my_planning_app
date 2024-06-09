import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:flutter_tests/util/color_palette.dart';

class MyAdvencedCalendar extends StatefulWidget {
  final AdvancedCalendarController controller;
  const MyAdvencedCalendar({super.key, required this.controller});

  @override
  State<MyAdvencedCalendar> createState() => _AdvencedCalendarState();
}

class _AdvencedCalendarState extends State<MyAdvencedCalendar> {
  ThemeData theme = ThemeData.dark();

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: theme.copyWith(
          textTheme: theme.textTheme.copyWith(
            titleMedium: theme.textTheme.titleMedium!.copyWith(
              fontSize: 16,
              color: txt,
            ),
            //строка с днями недели
            bodyLarge: theme.textTheme.bodyLarge!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: theme.textTheme.bodyMedium!.copyWith(
              fontSize: 12,
              color: txt,
            ),
          ),
          primaryColor: brand,
          highlightColor: txt,
          disabledColor: hintTxt,
          hintColor: txt, //цвет для дней недели
        ),
        child: AdvancedCalendar(
          controller: widget.controller,
          events: [DateTime.now()],
          weekLineHeight: 32.0,
          startWeekDay: 1,
          innerDot: true,
          keepLineSize: false,
          calendarTextStyle: const TextStyle(
            color: txt,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            height: 1.3125,
            letterSpacing: 0,
          ),
        ));
  }
}
