// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:flutter_tests/data/habits.dart';
import 'package:flutter_tests/data/todo_list.dart';
import 'package:flutter_tests/util/color_palette.dart';
import 'package:flutter_tests/widgets/my_appbar.dart';
import 'package:flutter_tests/widgets/right_menu.dart';
import 'package:flutter_tests/widgets/calendar_picker.dart';
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
  TextEditingController newTaskController = TextEditingController();
  AdvancedCalendarController controller = AdvancedCalendarController.today();

  List<Widget> allTaskForToday = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    dateForNewTask = DateTime.now();
    allTaskForToday = _getAllTaskForToday();
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
    todoDB.todoList.forEach((e) {
      if (DateFormat('dd MMM yyyy').format(e['date']) == DateFormat('dd MMM yyyy').format(selectDate)) {
        allTask.add(
          CheckboxListTile(
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
            subtitle: Text('todo', style: TextStyle(color: e['done'] ? hintTxt : txt)),
            overlayColor: const MaterialStatePropertyAll(brand),
            fillColor: const MaterialStatePropertyAll(shadowDark),
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
        allTask.add(CheckboxListTile(
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
          subtitle: Text('todo', style: TextStyle(color: e['done'] ? hintTxt : txt)),
          overlayColor: const MaterialStatePropertyAll(brand),
          fillColor: const MaterialStatePropertyAll(shadowDark),
        ));
      }
    });
//выбираем привычки
    habitsDB.habbitsList.forEach((e) {
      if (e['progress'].containsKey(DateFormat('dd MMM yyyy').format(selectDate)) && DateFormat('dd MMM yyyy').format(selectDate) == DateFormat('dd MMM yyyy').format(DateTime.now())) {
        allTask.add(CheckboxListTile(
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
          overlayColor: const MaterialStatePropertyAll(brand),
          fillColor: const MaterialStatePropertyAll(shadowDark),
        ));
      } else if (e['progress'].containsKey(DateFormat('dd MMM yyyy').format(selectDate))) {
        allTask.add(CheckboxListTile(
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
          overlayColor: const MaterialStatePropertyAll(brand),
          fillColor: const MaterialStatePropertyAll(shadowDark),
        ));
      }
    });

    return allTask;
  }

  void _addTodo() {
    if (newTaskController.text.isNotEmpty) {
      setState(() {
        todoDB.addTodoItem(newTaskController.text, false, dateForNewTask);
        allTaskForToday = _getAllTaskForToday();
        dateForNewTask = DateTime.now();
      });
      Navigator.pop(context);
      newTaskController.text = '';
      dateForNewTask = DateTime.now();
    }
  }

  Future<void> _selectDate(Function setDialogState) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  surface: Theme.of(context).scaffoldBackgroundColor,
                  primary: brand, // header background color
                  onPrimary: txt, // header text color
                  onSurface: txt, // body text color
                ),
            dialogBackgroundColor: Colors.white, // background color of the date picker dialog
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
          insetPadding: const EdgeInsets.only(top: 10, bottom: 300, left: 20, right: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.all(0),
          contentTextStyle: const TextStyle(color: txt),
          backgroundColor: bg,
          elevation: 0,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 120,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  controller: newTaskController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter a task',
                  ),
                  style: const TextStyle(color: txt),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text(DateFormat('dd.MM.yyyy').format(dateForNewTask)),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(setDialogState),
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(shadowDark),
                    ),
                    child: const Text('Select date',
                        style: TextStyle(
                          color: txt,
                        )),
                  )
                ],
              )
            ]),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: _addTodo,
                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                child: const Text(
                  'Add',
                  style: TextStyle(color: brand, fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () => {Navigator.pop(context), newTaskController.text = '', dateForNewTask = DateTime.now()},
                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: txt, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _toggleTodoStatus(String id, bool? checked) {
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
          MyAdvencedCalendar(controller: controller),
          Expanded(
            child: ListView.builder(itemCount: allTaskForToday.length, itemBuilder: (context, index) => allTaskForToday[index]),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _addTodoDialog,
        backgroundColor: brand,
        child: const Icon(
          Icons.add,
          color: shadowDark,
          size: 16,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
