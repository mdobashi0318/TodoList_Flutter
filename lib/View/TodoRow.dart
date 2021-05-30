import 'package:flutter/material.dart';
import 'package:todolist/model/TodoModel.dart';

class TodoRow extends StatelessWidget {
  TodoRow({Key key, this.todoModel, this.onTap}) : super(key: key);

  final TodoModel todoModel;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          todoModel.title,
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          todoModel.date,
          style: TextStyle(fontSize: 18),
        ),
        onTap: onTap,
      ),
    );
  }
}
