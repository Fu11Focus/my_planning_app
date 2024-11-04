// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:ToDoDude/widgets/bottom_nav_bar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ToDoDude/data/habits.dart';
import 'package:ToDoDude/data/todo_list.dart';
import 'package:ToDoDude/my_icons_icons.dart';
import 'package:ToDoDude/util/color_palette.dart';
import 'package:ToDoDude/widgets/my_appbar.dart';
import 'package:ToDoDude/widgets/neo_container.dart';
import 'package:ToDoDude/widgets/neomorphism_button.dart';
import 'package:ToDoDude/widgets/right_menu.dart';
import 'package:ToDoDude/widgets/calendar_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final _myBox = Hive.box('ToDoListBox');
  TodoList todoDB = TodoList();
  final habitBox = Hive.box('HabitsBox');
  HabitsDB habitsDB = HabitsDB();

  DateTime selectDate = DateTime.now();
  late DateTime dateForNewTask;
  late DateTime notificationTime;
  late bool notificationIsNotEmpty;

  TextEditingController newTaskController = TextEditingController();
  AdvancedCalendarController controller = AdvancedCalendarController.today();

  List<Widget> allTaskForToday = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    dateForNewTask = DateTime.now();
    allTaskForToday = _getAllTaskForToday();
    notificationTime = DateTime.now();
    notificationIsNotEmpty = false;
  }

  void _initializeData() {
    if (_myBox.get('TODOLIST') == null) {
      todoDB.createInitialData();
    } else {
      todoDB.loadData();
    }
    if (habitBox.get('HABITS') == null) {
      habitsDB.createInitialData();
    } else {
      habitsDB.loadData();
    }
  }

  List<Widget> _getAllTaskForToday() {
    List<Widget> allTask = [];
    for (var e in todoDB.todoList) {
      if (DateFormat('dd MMM yyyy').format(e['date']) == DateFormat('dd MMM yyyy').format(selectDate)) {
        allTask.add(
          Slidable(
            endActionPane: ActionPane(motion: const StretchMotion(), children: [
              SlidableAction(
                autoClose: true,
                onPressed: (context) => setState(() {
                  todoDB.deleteToDoItem(e['id']);
                  allTaskForToday = _getAllTaskForToday();
                }),
                icon: MyIcons.trash,
                backgroundColor: bg,
              )
            ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: NeoContainer(
                child: Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: CheckboxListTile(
                    checkColor: brand,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      e['title'],
                      style: TextStyle(
                        color: e['done'] ? hintTxt : txt,
                        decoration: e['done'] ? TextDecoration.lineThrough : TextDecoration.none,
                        decorationColor: hintTxt,
                      ),
                    ),
                    value: e['done'],
                    onChanged: (checked) {
                      _toggleTodoStatus(e['id'], checked);
                    },
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('todo', style: TextStyle(color: e['done'] ? hintTxt : txt)),
                        e['notification'] != null
                            ? Row(
                                children: [
                                  Icon(Icons.notifications_rounded, color: e['done'] ? hintTxt : txt, size: 16),
                                  Text(DateFormat('Hm').format(e['notification']), style: TextStyle(color: e['done'] ? hintTxt : txt)),
                                ],
                              )
                            : const Text(''),
                      ],
                    ),
                    fillColor: const MaterialStatePropertyAll(shadowDark),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      if (DateTime(e['date'].year, e['date'].month, e['date'].day).isBefore(DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          )) &&
          !e['done'] &&
          DateFormat('dd MMM yyyy').format(DateTime.now()) == DateFormat('dd MMM yyyy').format(selectDate)) {
        allTask.add(
          Slidable(
              endActionPane: ActionPane(motion: const StretchMotion(), children: [
                SlidableAction(
                  autoClose: true,
                  onPressed: (context) => setState(() {
                    todoDB.deleteToDoItem(e['id']);
                    allTaskForToday = _getAllTaskForToday();
                  }),
                  icon: MyIcons.trash,
                  backgroundColor: bg,
                )
              ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: NeoContainer(
                  child: Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: CheckboxListTile(
                      checkColor: brand,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        e['title'] + ' (${DateFormat('dd.MM.yyyy').format(e['date'])})',
                        style: TextStyle(
                          color: Colors.red[300],
                          decoration: e['done'] ? TextDecoration.lineThrough : TextDecoration.none,
                          decorationColor: hintTxt,
                        ),
                      ),
                      value: e['done'],
                      onChanged: (checked) {
                        _toggleTodoStatus(e['id'], checked);
                      },
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('todo', style: TextStyle(color: e['done'] ? hintTxt : txt)),
                          e['notification'] != null
                              ? Row(
                                  children: [const Icon(Icons.notifications_rounded, color: txt, size: 16), Text(DateFormat('Hm').format(e['notification']), style: const TextStyle(color: txt))],
                                )
                              : const Text(''),
                        ],
                      ),
                      fillColor: const MaterialStatePropertyAll(shadowDark),
                    ),
                  ),
                ),
              )),
        );
      }
    }
//выбираем привычки
    for (var e in habitsDB.habbitsList) {
      if (e['progress'].containsKey(DateFormat('dd MMM yyyy').format(selectDate)) && DateFormat('dd MMM yyyy').format(selectDate) == DateFormat('dd MMM yyyy').format(DateTime.now())) {
        allTask.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: NeoContainer(
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: CheckboxListTile(
                  checkColor: brand,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    e['title'],
                    style: TextStyle(
                      color: e['progress'][DateFormat('dd MMM yyyy').format(selectDate)] ? hintTxt : txt,
                      decoration: e['progress'][DateFormat('dd MMM yyyy').format(selectDate)] ? TextDecoration.lineThrough : TextDecoration.none,
                      decorationColor: hintTxt,
                    ),
                  ),
                  value: e['progress'][DateFormat('dd MMM yyyy').format(selectDate)],
                  onChanged: (checked) {
                    _toggleHabitStatus(e['id'], checked);
                  },
                  subtitle: Text('habit', style: TextStyle(color: e['progress'][DateFormat('dd MMM yyyy').format(selectDate)] ? hintTxt : txt)),
                  fillColor: const MaterialStatePropertyAll(shadowDark),
                ),
              ),
            ),
          ),
        );
      } else if (e['progress'].containsKey(DateFormat('dd MMM yyyy').format(selectDate))) {
        allTask.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: NeoContainer(
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: CheckboxListTile(
                  checkColor: brand,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    e['title'],
                    style: TextStyle(
                      color: e['progress'][DateFormat('dd MMM yyyy').format(selectDate)] ? hintTxt : txt,
                      decoration: e['progress'][DateFormat('dd MMM yyyy').format(selectDate)] ? TextDecoration.lineThrough : TextDecoration.none,
                      decorationColor: hintTxt,
                    ),
                  ),
                  value: e['progress'][DateFormat('dd MMM yyyy').format(selectDate)],
                  onChanged: (checked) {
                    final snackBar = SnackBar(content: Text('This day has not yet come!', style: TextStyle(color: Colors.red[300])));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  subtitle: Text('habit', style: TextStyle(color: e['progress'][DateFormat('dd MMM yyyy').format(selectDate)] ? hintTxt : txt)),
                  // overlayColor: const MaterialStatePropertyAll(brand),
                  fillColor: const MaterialStatePropertyAll(shadowDark),
                ),
              ),
            ),
          ),
        );
      }
    }
    return allTask;
  }

  void _addTodo() {
    int notificationId = Random().nextInt(10000000);
    DateTime notificationTimeForTask = DateTime(dateForNewTask.year, dateForNewTask.month, dateForNewTask.day, notificationTime.hour, notificationTime.minute);
    if (newTaskController.text.isNotEmpty) {
      setState(() {
        todoDB.addTodoItem(newTaskController.text, false, dateForNewTask, notificationIsNotEmpty ? notificationTimeForTask : null, notificationIsNotEmpty ? notificationId : null);
        allTaskForToday = _getAllTaskForToday();
        dateForNewTask = DateTime.now();
      });
      Navigator.pop(context);
      newTaskController.text = '';
      notificationIsNotEmpty = false;
      notificationTime = DateTime.now();
    }
  }

  void changeNotificationEmpty(Function setDialogState) {
    setDialogState(() {
      notificationIsNotEmpty = !notificationIsNotEmpty;
    });
  }

  Future<void> _selectDate(Function setDialogState) async {
    DateTime? picked = await showDatePicker(
      barrierDismissible: false,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
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
      },
    );

    if (picked != null) {
      setDialogState(() {
        dateForNewTask = picked;
      });
    }
  }

  void _addTodoDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          actionsPadding: const EdgeInsets.all(0),
          insetPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.all(0),
          contentTextStyle: const TextStyle(color: txt),
          backgroundColor: bg,
          elevation: 0,
          content: SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            height: 160,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color: Colors.transparent, boxShadow: [BoxShadow(color: shadowDark), BoxShadow(color: bg, spreadRadius: -5, blurRadius: 5)]),
                  child: TextField(
                    controller: newTaskController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter a task',
                    ),
                    style: const TextStyle(color: txt),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text('Date:'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(DateFormat('dd.MM.yyyy').format(dateForNewTask)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              child: NeomorphismButton(
                                action: () => _selectDate(setDialogState),
                                height: 30,
                                width: 30,
                                child: const Icon(Icons.arrow_drop_down, color: txt),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Notification",
                            ),
                            Checkbox(
                              value: notificationIsNotEmpty,
                              onChanged: (value) => changeNotificationEmpty(setDialogState),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(notificationIsNotEmpty ? DateFormat('Hm').format(notificationTime) : "All day"),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              child: NeomorphismButton(
                                action: () => setNotificationTimeDialog(setDialogState),
                                height: 30,
                                width: 30,
                                child: const Icon(Icons.notifications_rounded, color: txt, size: 18),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ]),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20, top: 20),
              child: NeomorphismButton(
                action: _addTodo,
                height: 40,
                width: 80,
                child: const Text('Add', style: TextStyle(color: txt, fontSize: 18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20, top: 20),
              child: NeomorphismButton(
                action: () => {
                  Navigator.pop(context),
                  newTaskController.text = '',
                  dateForNewTask = DateTime.now(),
                  notificationIsNotEmpty = false,
                },
                height: 40,
                width: 80,
                child: const Text('Cancel', style: TextStyle(color: txt, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTodoStatus(String id, bool? checked) {
    if (checked != null) {
      int index = todoDB.todoList.indexWhere((e) => e['id'] == id);
      checked && todoDB.todoList[index]['notificationId'] != null ? AwesomeNotifications().cancel(todoDB.todoList[index]['notificationId']) : null;
    }
    setState(() {
      todoDB.toDone(id, checked);
      allTaskForToday = _getAllTaskForToday();
    });
  }

  void _toggleHabitStatus(String id, bool? checked) {
    setState(() {
      habitsDB.toDayIsDone(id, checked, selectDate);
      allTaskForToday = _getAllTaskForToday();
    });
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      setState(() {
        selectDate = controller.value;
        allTaskForToday = _getAllTaskForToday();
      });
    });
    return Scaffold(
        endDrawer: const RightMenu(thisPage: 'Calendar'),
        drawerScrimColor: Colors.transparent,
        appBar: const MyAppBar(icon: Icons.calendar_month_outlined, text: 'Calendar'),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: MyAdvencedCalendar(controller: controller),
            ),
            Expanded(
              child: ListView.builder(itemCount: allTaskForToday.length, itemBuilder: (context, index) => allTaskForToday[index]),
            )
          ],
        ),
        bottomNavigationBar: BottomNavBar(action: _addTodoDialog));
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
        notificationTime = DateTime(dateForNewTask.year, dateForNewTask.month, dateForNewTask.day, selectedTime.hour, selectedTime.minute);
      }
    });
  }
}
