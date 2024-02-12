import 'package:flutter/material.dart';
import 'package:flutter_tests/util/color_palette.dart';

class CreateNotePage extends StatelessWidget {
  const CreateNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                    controller: TextEditingController(text: 'New note'),
                    maxLines: 2,
                    style: const TextStyle(
                        color: txt, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Text(
                        'Close',
                        style: TextStyle(
                          color: brand,
                          fontSize: 18,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Icon(
                        Icons.close,
                        color: brand,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const TextField(
            style: TextStyle(color: txt, fontSize: 18),
            maxLines: null,
            decoration: InputDecoration(hintText: 'Enter anything...'),
          )
        ],
      ),
    );
  }
}
