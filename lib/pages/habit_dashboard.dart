// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tests/util/color_palette.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/neo_container.dart';
import 'package:flutter_tests/widgets/right_menu.dart';
import 'package:intl/intl.dart';

class HabitDashboard extends StatefulWidget {
  const HabitDashboard({super.key});
  @override
  State<HabitDashboard> createState() => _HabitDashboardState();
}

class _HabitDashboardState extends State<HabitDashboard> {
  late var habit;

  @override
  Widget build(BuildContext context) {
    Map? arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arguments != null) {
      habit = arguments['habit'];
    }
    return Scaffold(
        endDrawer: RightMenu(thisPage: 'Dashboard'),
        appBar: MyAppBar(icon: Icons.add_chart, text: 'Dashboard'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: NeoContainer(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        habit['title'].toUpperCase(),
                        style: TextStyle(color: txt, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('${DateFormat('dd.MM.yyyy').format(habit['start'])} - ${DateFormat('dd.MM.yyyy').format(habit['finish'])}', style: TextStyle(color: txt)),
                    ],
                  ),
                )),
              ),
              Row(
                children: [
                  //выполненный процент
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width - 60) / 2,
                      height: 120,
                      child: const NeoContainer(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedNumber(number: 43),
                                  Text(
                                    '%',
                                    style: TextStyle(color: hintTxt, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              Text(
                                'Prossent',
                                style: TextStyle(color: hintTxt, fontSize: 16),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  //выполнено дней из общего кол-ва деней
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width - 60) / 2,
                      height: 120,
                      child: const NeoContainer(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedNumber(number: 43),
                                  Text(
                                    '/ ',
                                    style: TextStyle(color: hintTxt, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  AnimatedNumber(number: 84),
                                ],
                              ),
                              Text(
                                'Days is done',
                                style: TextStyle(color: hintTxt, fontSize: 16),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  //лучший стрик
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width - 60) / 2,
                      height: 120,
                      child: const NeoContainer(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              AnimatedNumber(number: 17),
                              Text(
                                'Best streak',
                                style: TextStyle(color: hintTxt, fontSize: 16),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  //текущий стрик
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width - 60) / 2,
                      height: 120,
                      child: const NeoContainer(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              AnimatedNumber(number: 7),
                              Text(
                                'Streak',
                                style: TextStyle(color: hintTxt, fontSize: 16),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class AnimatedNumber extends StatefulWidget {
  final int number;
  const AnimatedNumber({super.key, required this.number});

  @override
  _AnimatedNumberState createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<AnimatedNumber> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: widget.number), // Конечное значение числа
      duration: const Duration(seconds: 2), // Продолжительность анимации
      builder: (context, value, child) {
        return Text(value.toString(), style: const TextStyle(color: txt, fontSize: 24));
      },
    );
  }
}
