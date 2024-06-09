// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:flutter_tests/data/habits.dart';
// import 'package:flutter_tests/data/todo_list.dart';
// import 'package:flutter_tests/util/color_palette.dart';
// import 'package:flutter_tests/widgets/my_appbar.dart';
// import 'package:flutter_tests/widgets/right_menu.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:intl/intl.dart';

// class Today extends StatefulWidget {
//   const Today({super.key});

//   @override
//   State<Today> createState() => _TodayState();
// }

// class _TodayState extends State<Today> {
//   final _myBox = Hive.box('ToDoListBox');
//   TodoList db = TodoList();
//   final habitBox = Hive.box('HabitsBox');
//   HabitsDB habitsDB = HabitsDB();

//   List tasks = [];
//   TextEditingController newTaskController = TextEditingController();
//   @override
//   void initState() {
//     if (_myBox.get('TODOLIST') == null) {
//       db.createInitialData();
//     } else {
//       db.loadData();
//     }
//     if (habitBox.get('HABITS') == null) {
//       habitsDB.createInitialData();
//     } else {
//       habitsDB.loadData();
//     }
//     updateTaskList();
//     super.initState();
//   }

//   void updateTaskList() {
//     //выбираем туду-задачи у которых дата создания сегодня или они не выполнены в предыдущие дни
//     List todoList = db.todoList.where((element) => element['date'] == DateFormat('dd MMM yyyy').format(DateTime.now()) || element['done'] == false).toList(); //создаём новый лист из тасков, которые должны быть выполнены сегодня или не были выполнены в предыдущие дни
//     //выбираем привычки, у которых день недели для выполнения совпадает с сегодняшним
//     List habitsList = habitsDB.habbitsList.where((element) => element[DateFormat('EEE').format(DateTime.now()).toString()] == true).map(
//       (e) {
//         e['done'] = e['progress'].containsKey(DateFormat('dd MMM yyyy').format(DateTime.now())) ? e['progress'][DateFormat('dd MMM yyyy').format(DateTime.now())] : false;
//         e['date'] = DateFormat('dd MMM yyyy').format(DateTime.now());
//         return e;
//       },
//     ).toList();
//     tasks = todoList + habitsList;
//   }

//   void addTodo() {
//     if (newTaskController.text.isNotEmpty) {
//       setState(() {
//         db.addTodoItem({'title': newTaskController.text, 'type': 'todo', 'done': false, 'date': DateFormat('dd MMM yyyy').format(DateTime.now())});
//         updateTaskList();
//       });
//       Navigator.pop(context);
//       newTaskController.text = '';
//     }
//   }



//   //функия изменения статуса выполнено\не выполнено для задачи
//   void toDone(index, done) {
//     int indexTask = db.todoList.indexWhere((element) => element == tasks[index]); //получаем индекс нужной таски в базе данных
//     db.toDone(indexTask);
//     setState(() {
//       updateTaskList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       endDrawer: const RightMenu(thisPage: 'Today'),
//       appBar: const MyAppBar(icon: Icons.calendar_today_outlined, text: 'Today'),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: tasks.length,
//               itemBuilder: (context, index) => CheckboxListTile(
//                 value: tasks[index]['done'],
//                 onChanged: (checked) => tasks[index]['type'] == 'todo'
//                     ? toDone(index, checked)
//                     : setState(() {
//                         habitsDB.toDayIsDone(tasks[index]['title'], checked);
//                         tasks[index]['done'] = checked;
//                       }),
//                 title: Text(tasks[index]['date'] == DateFormat('dd MMM yyyy').format(DateTime.now()) ? tasks[index]['title'] : '${tasks[index]['title']}(${tasks[index]['date']})', style: TextStyle(color: tasks[index]['done'] ? hintTxt : (tasks[index]['date'] == DateFormat('dd MMM yyyy').format(DateTime.now()) ? txt : Colors.red[300]), fontWeight: FontWeight.bold, decorationColor: hintTxt, decoration: tasks[index]['done'] ? TextDecoration.lineThrough : TextDecoration.none)),
//                 subtitle: Text(tasks[index]['type'], style: TextStyle(color: tasks[index]['done'] ? hintTxt : txt)),
//                 overlayColor: MaterialStatePropertyAll(brand),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: addTodoDialog,
//         backgroundColor: brand,
//         child: Icon(
//           Icons.add,
//           size: 20,
//         ),
//       ),
//     );
//   }
// }
