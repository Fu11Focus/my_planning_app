// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:ToDoDude/services/notification_service.dart';
import 'package:ToDoDude/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ToDoDude/data/habits.dart';
import 'package:ToDoDude/my_icons_icons.dart';
import 'package:ToDoDude/util/color_palette.dart';
import 'package:ToDoDude/widgets/my_appbar.dart';
import 'package:ToDoDude/widgets/right_menu.dart';
import 'package:ToDoDude/widgets/week_day_button.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../widgets/neomorphism_button.dart';

class HabitsTracker extends StatefulWidget {
  const HabitsTracker({super.key});

  @override
  State<HabitsTracker> createState() => _HabitsTrackerState();
}

TextEditingController editNewHabitController = TextEditingController();
DateTime dateForNewTask = DateTime.now();
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
DateTime startNewHabit = DateTime.now();
DateTime finishNewHabit = DateTime.now().add(Duration(days: 30));
final _myBox = Hive.box('HabitsBox');
HabitsDB dbHabits = HabitsDB();
NotificationService habitNotificationService = NotificationService();
DateTime notificationTime = DateTime.now();

class _HabitsTrackerState extends State<HabitsTracker> {
  void saveHabit({id = -1}) {
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
      if (tamp.isEmpty) {
        //ни один день недели не выбран
        final snackBar = SnackBar(content: Text('Select days of week!', style: TextStyle(color: Colors.red[300])));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        int notificationId = Random().nextInt(10000000);
        setState(() {
          dbHabits.addHabit(editNewHabitController.text, tamp, startNewHabit, finishNewHabit, habitNotificationService.notificationIsNotEmpty ? notificationTime : null, habitNotificationService.notificationIsNotEmpty ? notificationId : null);
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
        habitNotificationService.notificationIsNotEmpty = false;
        Navigator.pop(context);
      }
    } else {
      //название привычки не задано
      final snackBar = SnackBar(content: Text('Enter habit name', style: TextStyle(color: Colors.red[300])));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  Future<void> _selectStartDate(Function setDialogState) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              surface: Theme.of(context).scaffoldBackgroundColor,
              primary: brand, // header background color
              onSurface: txt, // body text color
            ),
            dialogBackgroundColor: Colors.black, // background color of the date picker dialog
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setDialogState(() {
        startNewHabit = picked;
      });
    }
  }

  Future<void> _selectFinishDate(Function setDialogState) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData().copyWith(
            colorScheme: ColorScheme.dark(
              surface: bg, //bg
              primary: brand, // header background color
              onSurface: txt, // body text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setDialogState(() {
        finishNewHabit = picked;
      });
    }
  }

  void setNotificationTimeDialog(setState) async {
    TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              applyElevationOverlayColor: false,
              colorScheme: const ColorScheme.dark(
                surface: bg,
                primary: brand, // header background color
                onSurface: txt, // body text color
              ),
            ),
            child: child!,
          );
        });
    setState(() {
      if (selectedTime != null) {
        //                   DateTime(year, month, day, hour, minute)
        notificationTime = DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute);
      }
    });
  }

  void createHabitDialog(
      {title = '',
      daysOfWeekHabit = const {
        'Sun': false,
        'Mon': false,
        'Tue': false,
        'Wed': false,
        'Thu': false,
        'Fri': false,
        'Sat': false,
      },
      id = -1}) {
    editNewHabitController.text = title;
    daysOfWeek = daysOfWeekHabit;
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  iconColor: txt,
                  backgroundColor: bg,
                  elevation: 0,
                  insetPadding: EdgeInsets.symmetric(horizontal: 10),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 250,
                    child: ListView(
                      children: [
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.transparent, boxShadow: const [BoxShadow(color: shadowDark), BoxShadow(color: bg, spreadRadius: -5, blurRadius: 5)]),
                          child: TextField(
                            controller: editNewHabitController,
                            style: const TextStyle(color: txt),
                            decoration: InputDecoration(
                              hintText: 'Enter habit',
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              fillColor: txt,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Select day for repeat:',
                                style: TextStyle(color: txt),
                              ),
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
                            ),
                          ],
                        ),
                        //block for selecting date start\end
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //start column
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  'Start:',
                                  style: TextStyle(color: txt),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        DateFormat('dd.MM.yyyy').format(startNewHabit),
                                        style: TextStyle(color: txt),
                                      ),
                                    ),
                                    NeomorphismButton(
                                      action: () => _selectStartDate(setState),
                                      height: 30,
                                      width: 30,
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        color: txt,
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                              //finish column
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('Finish:', style: TextStyle(color: txt)),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        DateFormat('dd.MM.yyyy').format(finishNewHabit),
                                        style: TextStyle(color: txt),
                                      ),
                                    ),
                                    NeomorphismButton(
                                      action: () => _selectFinishDate(setState),
                                      height: 30,
                                      width: 30,
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        color: txt,
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text("Notification", style: TextStyle(color: txt)),
                                Checkbox(
                                  value: habitNotificationService.notificationIsNotEmpty,
                                  onChanged: (value) => habitNotificationService.changeNotificationEmpty(setState),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(habitNotificationService.notificationIsNotEmpty ? DateFormat('Hm').format(notificationTime) : "All day", style: TextStyle(color: txt)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                  child: NeomorphismButton(
                                    action: () => habitNotificationService.notificationIsNotEmpty ? setNotificationTimeDialog(setState) : null,
                                    height: 30,
                                    width: 30,
                                    child: const Icon(Icons.notifications_rounded, color: txt, size: 18),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 0),
                      child: NeomorphismButton(
                        action: () => saveHabit(id: id),
                        height: 40,
                        width: 80,
                        child: const Text('Save', style: TextStyle(color: txt, fontSize: 18)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 0),
                      child: NeomorphismButton(
                        action: () {
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
                        height: 40,
                        width: 80,
                        child: const Text('Cancel', style: TextStyle(color: txt, fontSize: 18)),
                      ),
                    ),
                  ],
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const RightMenu(thisPage: 'Habits'),
        appBar: const MyAppBar(icon: Icons.task_alt_sharp, text: 'Habits'),
        body: habitsList.isEmpty
            ? Center(
                child: Text(
                  'Enter on "+" for create ur first habit.',
                  style: TextStyle(color: hintTxt, fontSize: 20),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ListView.builder(
                  itemCount: habitsList.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/habitDashboard', arguments: {'habit': dbHabits.habbitsList[index]}),
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
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color(0xff24262b),
                                    Color(0xff36383d)
                                  ], stops: [
                                    0.4,
                                    1,
                                  ], begin: Alignment.topLeft, end: Alignment.bottomRight, transform: GradientRotation(0.9)),
                                  borderRadius: BorderRadius.circular(12),
                                  /*border: Border.all(color: shadowLight),*/ boxShadow: const [BoxShadow(color: shadowDark, offset: Offset(5, 5), blurRadius: 10), BoxShadow(color: shadowLight, offset: Offset(-5, -5), blurRadius: 10)]),
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
                                        '${habitsList[index]['daysOfWeek'].contains('Sun') ? 'Sun ' : ''}${habitsList[index]['daysOfWeek'].contains('Mon') ? 'Mon ' : ''}${habitsList[index]['daysOfWeek'].contains('Tue') ? 'Tue ' : ''}${habitsList[index]['daysOfWeek'].contains('Wed') ? 'Wed ' : ''}${habitsList[index]['daysOfWeek'].contains('Thu') ? 'Thu ' : ''}${habitsList[index]['daysOfWeek'].contains('Fri') ? 'Fri ' : ''}${habitsList[index]['daysOfWeek'].contains('Sat') ? 'Sat' : ''}',
                                        style: TextStyle(
                                          color: txt,
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                        color: bg,
                                      ),
                                      Text('${DateFormat('dd.MM.yyyy').format(habitsList[index]['start'])} - ${DateFormat('dd.MM.yyyy').format(habitsList[index]['finish'])}', style: TextStyle(color: txt))
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
                      ),
                    );
                  }),
                ),
              ),
        bottomNavigationBar: BottomNavBar(action: () => createHabitDialog(daysOfWeekHabit: daysOfWeek)));
  }
}
