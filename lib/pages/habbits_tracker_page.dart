// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_tests/data/habits.dart';
import 'package:flutter_tests/my_icons_icons.dart';
import 'package:flutter_tests/util/color_palette.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/right_menu.dart';
import 'package:flutter_tests/widgets/week_day_button.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HabitsTracker extends StatefulWidget {
  const HabitsTracker({super.key});

  @override
  State<HabitsTracker> createState() => _HabitsTrackerState();
}

TextEditingController editNewHabitController = TextEditingController();

List habitsList = [];
Map daysOfWeek = {
  'Sun': false,
  'Mon': false,
  'Tue': false,
  'Wed': false,
  'Thu': false,
  'Fri': false,
  'Sat': false,
};
final _myBox = Hive.box('HabitsBox');
HabitsDB dbHabits = HabitsDB();

class _HabitsTrackerState extends State<HabitsTracker> {
  void saveHabit() {
    if (editNewHabitController.text.isNotEmpty) {
      List<String> tamp = [];
      if (daysOfWeek['Sun']) {
        tamp.add('Sun');
      }
      if (daysOfWeek['Mon']) {
        tamp.add('Mon');
      }
      if (daysOfWeek['Tue']) {
        tamp.add('Tue');
      }
      if (daysOfWeek['Wed']) {
        tamp.add('Wed');
      }
      if (daysOfWeek['Thu']) {
        tamp.add('Thu');
      }
      if (daysOfWeek['Fri']) {
        tamp.add('Fri');
      }
      if (daysOfWeek['Sat']) {
        tamp.add('Sat');
      }
      setState(() {
        dbHabits.addHabit(editNewHabitController.text, tamp);
        habitsList = dbHabits.habbitsList;
      });
      editNewHabitController.text = '';
      daysOfWeek = {
        'Sun': false,
        'Mon': false,
        'Tue': false,
        'Wed': false,
        'Thu': false,
        'Fri': false,
        'Sat': false,
      };
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    if (_myBox.get('HABITS') == null) {
      dbHabits.createInitialData();
    } else {
      dbHabits.loadData();
    }
    habitsList = dbHabits.habbitsList;
    super.initState();
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

  void createHabitDialog() {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  iconColor: txt,
                  backgroundColor: bg,
                  elevation: 0,
                  insetPadding: EdgeInsets.symmetric(horizontal: 10),
                  contentPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.person_2_outlined,
                        size: 22,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Add new habit', style: TextStyle(color: txt, fontSize: 18)),
                    ],
                  ),
                  titleTextStyle: TextStyle(color: txt),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextField(
                          controller: editNewHabitController,
                          style: const TextStyle(color: txt),
                          decoration: InputDecoration(
                            hintText: 'Enter habit',
                            contentPadding: EdgeInsets.all(0),
                            fillColor: txt,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select day for repeat:',
                              style: TextStyle(color: txt),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                WeekDayButton(
                                  onPress: () => setState(() {
                                    daysOfWeek['Sun'] = !daysOfWeek['Sun'];
                                  }),
                                  active: daysOfWeek['Sun'],
                                  dayOfWeek: 'Sun',
                                ),
                                WeekDayButton(
                                  onPress: () => setState(() {
                                    daysOfWeek['Mon'] = !daysOfWeek['Mon'];
                                  }),
                                  active: daysOfWeek['Mon'],
                                  dayOfWeek: 'Mon',
                                ),
                                WeekDayButton(
                                  onPress: () => setState(() {
                                    daysOfWeek['Tue'] = !daysOfWeek['Tue'];
                                  }),
                                  active: daysOfWeek['Tue'],
                                  dayOfWeek: 'Tue',
                                ),
                                WeekDayButton(
                                  onPress: () => setState(() {
                                    daysOfWeek['Wed'] = !daysOfWeek['Wed'];
                                  }),
                                  active: daysOfWeek['Wed'],
                                  dayOfWeek: 'Wed',
                                ),
                                WeekDayButton(
                                  onPress: () => setState(() {
                                    daysOfWeek['Thu'] = !daysOfWeek['Thu'];
                                  }),
                                  active: daysOfWeek['Thu'],
                                  dayOfWeek: 'Thu',
                                ),
                                WeekDayButton(
                                  onPress: () => setState(() {
                                    daysOfWeek['Fri'] = !daysOfWeek['Fri'];
                                  }),
                                  active: daysOfWeek['Fri'],
                                  dayOfWeek: 'Fri',
                                ),
                                WeekDayButton(
                                  onPress: () => setState(() {
                                    daysOfWeek['Sat'] = !daysOfWeek['Sat'];
                                  }),
                                  active: daysOfWeek['Sat'],
                                  dayOfWeek: 'Sat',
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: saveHabit,
                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 20,
                          color: brand,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        editNewHabitController.text = '';
                        daysOfWeek = {
                          'Sun': false,
                          'Mon': false,
                          'Tue': false,
                          'Wed': false,
                          'Thu': false,
                          'Fri': false,
                          'Sat': false,
                        };
                      },
                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 20, color: txt),
                      ),
                    ),
                  ],
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const RightMenu(thisPage: 'Habbits Tracker'),
      appBar: const MyAppBar(icon: Icons.task_alt_sharp, text: 'Habbits Tracker'),
      body: ListView.builder(
        itemCount: habitsList.length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Slidable(
              endActionPane: ActionPane(motion: const StretchMotion(), children: [
                SlidableAction(
                  autoClose: true,
                  onPressed: (context) => {
                    setState(() {
                      dbHabits.removeHabit(index);
                      habitsList = dbHabits.habbitsList;
                    })
                  },
                  icon: MyIcons.trash,
                  backgroundColor: bg,
                ),
              ]),
              child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: shadowLight), boxShadow: const [BoxShadow(color: shadowDark, offset: Offset(10, 10), blurRadius: 10), BoxShadow(color: shadowLight, offset: Offset(-10, -10), blurRadius: 10)]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habitsList[index]['title'].length > 25 ? '${habitsList[index]['title'].substring(0, 25)}...' : habitsList[index]['title'],
                            style: TextStyle(color: txt, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                          Divider(
                            height: 10,
                            color: bg,
                          ),
                          Text(
                            '${habitsList[index]['daysOfWeek'].contains('Sun') ? 'Sun ' : ''}${habitsList[index]['daysOfWeek'].contains('Mon') ? 'Mon ' : ''}${habitsList[index]['daysOfWeek'].contains('Mon') ? 'Tue ' : ''}${habitsList[index]['daysOfWeek'].contains('Wed') ? 'Wed ' : ''}${habitsList[index]['daysOfWeek'].contains('Thu') ? 'Thu ' : ''}${habitsList[index]['daysOfWeek'].contains('Fri') ? 'Fri ' : ''}${habitsList[index]['daysOfWeek'].contains('Sat') ? 'Sat' : ''}',
                            style: TextStyle(
                              color: txt,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Progress:\n${calculateHabitProgress(habitsList[index])}%',
                        style: TextStyle(
                          color: txt,
                        ),
                      ),
                    ],
                  )),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createHabitDialog,
        backgroundColor: brand,
        foregroundColor: shadowDark,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
