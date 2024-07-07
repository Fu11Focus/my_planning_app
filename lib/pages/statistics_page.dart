import 'package:flutter/material.dart';
import 'package:flutter_tests/data/habits.dart';
import 'package:flutter_tests/util/color_palette.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/neo_container.dart';
import 'package:flutter_tests/widgets/right_menu.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Statistics extends StatelessWidget {
  Statistics({super.key});
  final _myBox = Hive.box('HabitsBox');
  final dbHabits = HabitsDB();

  @override
  Widget build(BuildContext context) {
    if (_myBox.get('HABITS') == null) {
      dbHabits.createInitialData();
    } else {
      dbHabits.loadData();
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
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    height: 120,
                    child: const NeoContainer(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            AnimatedNumber(number: 43),
                            Text(
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
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    height: 120,
                    child: const NeoContainer(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [AnimatedNumber(number: 12), Text('the best days', style: TextStyle(color: hintTxt, fontSize: 16))],
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
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    height: 120,
                    child: const NeoContainer(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            AnimatedNumber(number: 21),
                            Text(
                              'best streak days',
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
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    height: 120,
                    child: const NeoContainer(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            AnimatedNumber(number: 15),
                            Text(
                              'streak days',
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
