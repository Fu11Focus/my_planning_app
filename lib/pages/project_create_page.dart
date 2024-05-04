import 'package:flutter/material.dart';
import 'package:flutter_tests/util/color_palette.dart';
import 'package:flutter_tests/widgets/neomorphism_button.dart';

class ProjectCreate extends StatefulWidget {
  const ProjectCreate({super.key});

  @override
  State<ProjectCreate> createState() => _ProjectCreateState();
}

class _ProjectCreateState extends State<ProjectCreate> {
  @override
  void addTask() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.15,
              left: 20,
              right: 20,
              bottom: 0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/projects');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Close',
                    style: TextStyle(color: brand, fontSize: 24),
                  ),
                  Icon(
                    Icons.close,
                    color: brand,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: shadowDark, offset: Offset(9, 9), blurRadius: 15), BoxShadow(color: shadowLight, offset: Offset(-9, -9), blurRadius: 15)]),
            child: const TextField(
              style: TextStyle(color: txt, fontSize: 24),
              decoration: InputDecoration(hintText: 'Title of your project', focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: shadowDark, offset: Offset(9, 9), blurRadius: 15), BoxShadow(color: shadowLight, offset: Offset(-9, -9), blurRadius: 15)]),
            child: const TextField(
              style: TextStyle(color: txt, fontSize: 18),
              maxLines: null,
              decoration: InputDecoration(hintText: 'Description...', focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: shadowDark, offset: Offset(9, 9), blurRadius: 15), BoxShadow(color: shadowLight, offset: Offset(-9, -9), blurRadius: 15)]),
                child: const TextField(
                  style: TextStyle(color: txt, fontSize: 18),
                  decoration: InputDecoration(hintText: 'Task', focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15)))),
                ),
              ),
              NeomorphismButton(
                action: addTask,
                height: 50,
                width: 50,
                child: const Icon(
                  Icons.add,
                  color: brand,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

/*
Создание действия
Вид действия
  1) Разовое
    1.1) выбрать конечную дату выполнения
  2) Периодичное
    2.1) Выбрать периодичность выполнения
      2.1.1) Дни недели
    2.2) Конечная дата (повторять действия до этого числа)
 */
