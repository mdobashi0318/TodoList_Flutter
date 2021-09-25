import 'package:flutter/material.dart';
import 'package:todolist/model/todo_model.dart';
import 'package:todolist/view/todo_details_screen.dart';
import 'package:todolist/view/widgets/todo_list_row_widget.dart';
import 'package:todolist/viewModel/todo_list_viewmodel.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key key, this.viewModel}) : super(key: key);

  final TodoListViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.model.length,
      itemBuilder: (context, index) {
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
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => TodoDetailsScreen(todoModel: model),
      ),
    ).then((_) => viewModel.allFetch());
  }
}
