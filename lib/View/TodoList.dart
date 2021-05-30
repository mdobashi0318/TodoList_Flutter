import 'package:flutter/material.dart';
import 'package:todolist/model/TodoModel.dart';
import 'package:todolist/view/TodoDetailsScreen.dart';
import 'package:todolist/view/TodoRow.dart';
import 'package:todolist/viewModel/TodoListViewModel.dart';

class TodoList extends StatelessWidget {
  TodoList({Key key, this.viewModel}) : super(key: key);

  final TodoListViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.model.length,
      itemBuilder: (BuildContext context, int index) {
        return TodoRow(
          todoModel: viewModel.model[index],
          onTap: () {
            _didTapTodoRow(
              context,
              viewModel.model[index],
            );
          },
        );
      },
    );
  }

  void _didTapTodoRow(BuildContext context, TodoModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoDetailsScreen(todoModel: model),
      ),
    ).then((value) => viewModel.allFetch());
  }
}
