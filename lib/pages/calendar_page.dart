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

  List allTaskForToday = [];

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

  List _getAllTaskForToday() {
    List todo = todoDB.todoList.where((element) => DateFormat('dd MMM yyyy').format(element['date']) == DateFormat('dd MMM yyyy').format(selectDate) || element['done'] == false).map((e) => {'id': e['id'], 'title': e['title'], 'type': 'todo', 'done': e['done'], 'date': e['date']}).toList();
    List habits = habitsDB.habbitsList.where((element) => element['daysOfWeek'].contains(DateFormat('EEE').format(selectDate).toString())).map((e) => {'id': e['id'], 'title': e['title'], 'type': 'habit', 'done': e['progress'].containsKey(DateFormat('dd MMM yyyy').format(selectDate)) ? e['progress'][DateFormat('dd MMM yyyy').format(selectDate)] : false, 'date': selectDate}).toList();
    return todo + habits;
  }

  void _addTodo() {
    if (newTaskController.text.isNotEmpty) {
      setState(() {
        todoDB.addTodoItem(newTaskController.text, false, dateForNewTask);
        allTaskForToday = _getAllTaskForToday();
      });
      Navigator.pop(context);
      newTaskController.text = '';
    }
  }

  Future<void> _selectDate(Function setDialogState) async {
    DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));

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
            height: 100,
            child: Column(children: [
              TextField(
                controller: newTaskController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter a task',
                ),
                style: const TextStyle(color: txt),
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
                onPressed: () => {Navigator.pop(context), newTaskController.text = ''},
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
            child: ListView.builder(
              itemCount: allTaskForToday.length,
              itemBuilder: (context, index) => CheckboxListTile(
                title: _getTitleSettings(index),
                value: allTaskForToday[index]['done'],
                onChanged: (checked) {
                  if (allTaskForToday[index]['type'] == 'todo') {
                    _toggleTodoStatus(allTaskForToday[index]['id'], checked);
                  } else {
                    _toggleHabitStatus(allTaskForToday[index]['id'], checked);
                  }
                },
                subtitle: Text(allTaskForToday[index]['type'], style: TextStyle(color: allTaskForToday[index]['done'] ? hintTxt : txt)),
                overlayColor: const MaterialStatePropertyAll(brand),
                fillColor: const MaterialStatePropertyAll(shadowDark),
              ),
            ),
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

  Widget _getTitleSettings(int index) {
    if (allTaskForToday[index]['type'] == 'todo') {
      return selectDate.isAfter(allTaskForToday[index]['date']) && selectDate.difference(allTaskForToday[index]['date']).inDays > 0.5
          ? Text('${allTaskForToday[index]['title']} (${DateFormat('dd MMM yyyy').format(allTaskForToday[index]['date'])})', style: TextStyle(color: Colors.red[300]))
          : allTaskForToday[index]['done']
              ? Text(allTaskForToday[index]['title'], style: const TextStyle(color: hintTxt, decorationColor: hintTxt, decoration: TextDecoration.lineThrough))
              : Text(allTaskForToday[index]['title'], style: const TextStyle(color: txt));
    } else {
      return Text(allTaskForToday[index]['title'], style: allTaskForToday[index]['done'] ? const TextStyle(color: hintTxt, decorationColor: hintTxt, decoration: TextDecoration.lineThrough) : const TextStyle(color: txt));
    }
  }
}
