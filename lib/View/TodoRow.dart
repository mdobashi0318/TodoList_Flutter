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
      title: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Column(
              children: [
                Text(model.title),
                Text(model.date),
              ],
            ),
          ],
        ),
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
