// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ToDoDude/util/color_palette.dart';
import 'package:ToDoDude/widgets/my_appbar.dart';
import 'package:ToDoDude/widgets/neo_container.dart';
import 'package:ToDoDude/widgets/right_menu.dart';
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

//получаем кол-во выполненых дней
    int getDaysIsDone() {
      int days = 0;
      habit['progress'].forEach((date, done) {
        if (done) days++;
      });
      return days;
    }

//текущий стрик
    int getStreakNow() {
      int days = 0;

      var newProgress = {};

      habit['progress'].forEach((dateKey, progress) {
        if (DateFormat("dd MMM yyyy").parse(dateKey).isAfter(DateTime.now())) {
          return;
        }
        if (!newProgress.containsKey(dateKey)) {
          newProgress[dateKey] = {};
        }
        newProgress[dateKey]![habit['title']] = progress;
      });
      List reversedProgress = newProgress.entries.toList().reversed.toList();
      int donedTasksForStreakNow = 0;
      for (var day in reversedProgress) {
        day.value.forEach((title, done) {
          if (done) donedTasksForStreakNow++;
        });
        if (day.value.length == donedTasksForStreakNow) {
          days++;
        } else {
          break;
        }
        donedTasksForStreakNow = 0;
      }
      return days;
    }

    int getBestStreak() {
      int days = 0;
      int bestStreak = 0;

      habit['progress'].forEach((title, done) {
        if (done) {
          days++;
        } else {
          if (days > bestStreak) {
            bestStreak = days;
          }
          days = 0;
        }
      });

      return bestStreak;
    }

    int calculateHabitProgress(Map habit) {
      int totalDays = habit['progress'].length;
      int completedDays = 0;

      habit['progress'].forEach((date, value) {
        if (value) {
          completedDays++;
        }
      });

      return (totalDays > 0 ? (completedDays / totalDays) * 100 : 0).round();
    }

    return Scaffold(
        endDrawer: RightMenu(thisPage: 'Dashboard'),
        appBar: MyAppBar(icon: Icons.add_chart, text: 'Dashboard'),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: NeoContainer(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      child: NeoContainer(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedNumber(number: calculateHabitProgress(habit)),
                                  Text(
                                    '%',
                                    style: TextStyle(color: hintTxt, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              Text(
                                'Progress',
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
                      child: NeoContainer(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedNumber(number: getDaysIsDone()),
                                  Text(
                                    '/ ',
                                    style: TextStyle(color: hintTxt, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  AnimatedNumber(number: habit['progress'].length),
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
                      child: NeoContainer(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedNumber(number: getBestStreak()),
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
                      child: NeoContainer(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedNumber(number: getStreakNow()),
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
