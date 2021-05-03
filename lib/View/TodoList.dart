import 'package:flutter/material.dart';
import 'package:todolist/model/TodoModel.dart';
import 'package:todolist/view/TodoRow.dart';

class TodoList extends StatefulWidget {
  TodoList({Key key, this.todoModel}) : super(key: key);

  final List<TodoModel> todoModel;

  @override
  _TodoList createState() => _TodoList();
}

class _TodoList extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: widget.todoModel.length,
      itemBuilder: (context, index) {
        return Card(
          child: TodoRow(
            todoModel: widget.todoModel[index],
          ),
        );
      },
    );
  }
}
