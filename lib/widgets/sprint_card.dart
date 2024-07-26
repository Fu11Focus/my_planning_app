
import 'package:flutter/material.dart';
import 'package:ToDoDude/util/color_palette.dart';

class SprintCard extends StatelessWidget {
  final String start, finish, img, status;
  const SprintCard({super.key, required this.start, required this.finish, required this.img, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 10,
      color: bg,
      surfaceTintColor: bg,
      shadowColor: shadowDark,
      shape: const RoundedRectangleBorder(side: BorderSide(color: shadowLight, width: 1), borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: 100,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) // Adjust the radius as needed
                  ),
              child: Image.network(
                'https://i.pinimg.com/564x/ef/83/51/ef8351843eeab4aadd30eba46ae44b80.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$start - $finish',
                  style: const TextStyle(color: txt),
                ),
                Text(
                  status,
                  style: const TextStyle(color: txt),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
