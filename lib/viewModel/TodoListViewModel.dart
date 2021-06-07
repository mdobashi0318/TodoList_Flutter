import 'package:flutter/material.dart';
import 'package:todolist/model/TodoModel.dart';

class TodoListViewModel extends ChangeNotifier {
  List<TodoModel> model = [];
  String message;
  final String noTodoMsg = "Todoがありません";

  TodoListViewModel() {
    allFetch();
  }

  Future<void> allFetch() async {
    message = "";
    await TodoModel().findAllTodo().then((value) {
      value.sort((a, b) {
        return a.date.compareTo(b.date);
      });
      model = value;
      if (value.isEmpty) {
        message = noTodoMsg;
      }
    }).catchError((error) {
      message = error;
    }).whenComplete(() => notifyListeners());
  }

  Future<void> allDelete() async {
    await TodoModel()
        .deleteALL()
        .then((_) {
          model = [];
          message = noTodoMsg;
        })
        .catchError((error) => message = error.toString())
        .whenComplete(() => notifyListeners());
  }
}
