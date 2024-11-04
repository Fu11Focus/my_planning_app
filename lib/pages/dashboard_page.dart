// ignore_for_file: avoid_print

import 'package:ToDoDude/data/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:ToDoDude/data/habits.dart';
import 'package:ToDoDude/util/color_palette.dart';
import 'package:ToDoDude/widgets/my_appbar.dart';
import 'package:ToDoDude/widgets/neo_container.dart';
import 'package:ToDoDude/widgets/right_menu.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../data/start_using_app.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});
  final _myBox = Hive.box('HabitsBox');
  final dbHabits = HabitsDB();
  final _myBox2 = Hive.box('ToDoListBox');
  final dbToDo = TodoList();
  final allDays = {};
  @override
  Widget build(BuildContext context) {
//считаем сколько дней в приложении
    int getDaysWithApp() {
      final myBox = Hive.box('StartUsingAppBox');
      StartApp startApp = StartApp();
      if (myBox.get('STARTAPP') == null) {
        startApp.createInitialData();
      } else {
        startApp.loadData();
      }
      return DateTime.now().difference(startApp.startUsingApp['date']).inDays;
    }

    //получаем все привички и задачи
    for (var task in dbToDo.todoList) {
      String dateKey = task['date'].toString().split(' ')[0];
      if (!allDays.containsKey(dateKey)) {
        allDays[dateKey] = {};
      }
      allDays[dateKey]![task['title']] = task['done'];
    }

    if (_myBox.get('HABITS') == null) {
      dbHabits.createInitialData();
    } else {
      dbHabits.loadData();
    }
    if (_myBox2.get('TODOLIST') == null) {
      dbToDo.createInitialData();
    } else {
      dbToDo.loadData();
    }
    // Добавление привычек в карту
    for (var habit in dbHabits.habbitsList) {
      habit['progress'].forEach((dateKey, progress) {
        if (DateFormat("dd MMM yyyy").parse(dateKey).isAfter(DateTime.now())) {
          return;
        }
        if (!allDays.containsKey(dateKey)) {
          allDays[dateKey] = {};
        }
        allDays[dateKey]![habit['title']] = progress;
      });
    }
    // the best days
    int donedTasks = 0;
    int bestDays = 0;
    allDays.forEach((date, day) {
      day.forEach((title, done) {
        done ? donedTasks++ : null;
      });
      if (donedTasks == day.length) {
        bestDays++;
      }
      donedTasks = 0;
    });
    //best streak days
    int daysForBestStreak = 0;
    int bestStreak = 0;
    int donedTasksForBestStreak = 0;
    allDays.forEach((date, tasks) {
      tasks.forEach((title, done) {
        if (done) {
          donedTasksForBestStreak++;
        }
      });
      if (donedTasksForBestStreak == tasks.length) {
        daysForBestStreak++;
        bestStreak = daysForBestStreak;
        donedTasksForBestStreak = 0;
      } else {
        if (daysForBestStreak > bestStreak) {
          bestStreak = daysForBestStreak;
          daysForBestStreak = 0;
        }
      }
    });
    //streak days
    List allDaysReversed = allDays.entries.toList().reversed.toList();
    int daysForStreakNow = 0;
    int donedTasksForStreakNow = 0;
    for (var day in allDaysReversed) {
      day.value.forEach((title, done) {
        if (done) donedTasksForStreakNow++;
      });
      if (day.value.length == donedTasksForStreakNow) {
        daysForStreakNow++;
      } else {
        break;
      }
      donedTasksForStreakNow = 0;
    }
    return Scaffold(
      endDrawer: const RightMenu(thisPage: 'Dashboard'),
      appBar: const MyAppBar(icon: Icons.add_chart, text: 'Dashboard'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                //кол-во дней в приложении
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    height: 120,
                    child: NeoContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedNumber(number: getDaysWithApp()),
                            const Text(
                              'days with ToDoDude',
                              style: TextStyle(color: hintTxt, fontSize: 16),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //кол-во идеальных дней
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    height: 120,
                    child: NeoContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [AnimatedNumber(number: bestDays), const Text('the best days', style: TextStyle(color: hintTxt, fontSize: 16))],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                //лучший стрик идеальных дней
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    height: 120,
                    child: NeoContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedNumber(number: bestStreak),
                            const Text(
                              'days best streak',
                              style: TextStyle(
                                color: hintTxt,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //текущий стрик идеальных дней
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    height: 120,
                    child: NeoContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedNumber(number: daysForStreakNow),
                            const Text(
                              'days streak',
                              style: TextStyle(
                                color: hintTxt,
                                fontSize: 16,
                              ),
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
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 0),
              child: Text(
                'HABITS:',
                style: TextStyle(
                  color: hintTxt,
                  fontSize: 24,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            //список привычек
            Column(
              children: [
                for (var habit in dbHabits.habbitsList)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/habitDashboard', arguments: {'habit': habit}),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: NeoContainer(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  habit['title'].toUpperCase(),
                                  style: const TextStyle(color: txt, fontWeight: FontWeight.bold),
                                ),
                                const Icon(
                                  Icons.arrow_circle_right,
                                  color: txt,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
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
