import 'package:flutter/material.dart';
import 'package:todolist/model/todo_model.dart';
import 'package:todolist/screen/widgets/todo_list_row_widget.dart';

import 'todo_list_viewmodel.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key key, this.model, this.viewModel}) : super(key: key);

  final List<TodoModel> model;

  final TodoListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (model.isEmpty) {
      return Center(child: Text(viewModel.noTodoMsg));
    }
    return ListView.builder(
      itemCount: model.length,
      itemBuilder: (context, index) {
        return TodoRow(
          todoModel: model[index],
          onTap: () {
            _didTapTodoRow(
              context,
              model[index],
            );
          },
        );
      },
    );
  }

  void _didTapTodoRow(BuildContext context, TodoModel model) {
    Navigator.of(context)
        .pushNamed('/detail', arguments: model)
        .then((_) => viewModel.fetchModels());
  }
}
