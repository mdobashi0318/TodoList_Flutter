import 'package:flutter/material.dart';
import 'package:todolist/model/TodoModel.dart';
import 'package:todolist/view/TodoDetailsScreen.dart';




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
          child: _todoRow(
            widget.todoModel[index].title,
            widget.todoModel[index].date,
            push,
          ),
        );
      },
    );
  }

  //
  void push() {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoDetailsScreen(),
          ));
    });
  }
}

Widget _todoRow(
  String title,
  String date,
  didTap,
) {
  return ListTile(
    title: Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Column(
            children: [
              Text(title),
              Text(date),
            ],
          ),
        ],
      ),
    ),
    onTap: () {
      didTap();
    },
  );
}
