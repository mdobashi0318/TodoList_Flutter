import 'package:flutter/material.dart';

class TodoRow extends StatelessWidget {
  const TodoRow(this.title, this.date, this.unfinished, {this.onTap, Key key})
      : super(key: key);

  final String title;
  final String date;
  final bool unfinished;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  date,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: 10,
                ),
                Chip(
                  label: Text(unfinished ? '未完了' : '完了',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black)),
                  backgroundColor: unfinished ? Colors.yellow : Colors.green,
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
