import 'package:flutter/material.dart';
import 'package:todolist/View/TodoDetailsScreen.dart';
import 'package:todolist/model/TodoModel.dart';

class TodoRow extends StatelessWidget {
  TodoRow({Key key, this.todoModel}) : super(key: key);

  final TodoModel todoModel;

  @override
  Widget build(BuildContext context) {
    return _todoRow(todoModel, context);
  }

  Widget _todoRow(TodoModel model, BuildContext context) {
    return ListTile(
      title: Text(
        model.title,
        style: TextStyle(fontSize: 18),
      ),
      subtitle: Text(
        model.detail,
        style: TextStyle(fontSize: 18),
      ),
      onTap: () {
        didTapTodoRow(todoModel, context);
      },
    );
  }

  void didTapTodoRow(TodoModel model, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodoDetailsScreen(todoModel: model),
        ));
  }
}
