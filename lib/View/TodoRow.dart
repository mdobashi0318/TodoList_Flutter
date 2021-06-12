import 'package:flutter/material.dart';
import 'package:todolist/model/TodoModel.dart';
import 'package:todolist/other/CompleteFlag.dart';

class TodoRow extends StatelessWidget {
  TodoRow({Key key, this.todoModel, this.onTap}) : super(key: key);

  final TodoModel todoModel;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    print("todoModel.completeFlag: ${todoModel.completeFlag.index}");
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
        leading: todoModel.completeFlag.index == CompleteFlag.unfinished.index
            ? Icon(Icons.check_box_outline_blank_rounded)
            : Icon(Icons.check_box_rounded),
        onTap: onTap,
      ),
    );
  }
}
