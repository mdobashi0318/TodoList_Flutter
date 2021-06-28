import 'package:flutter/material.dart';
import 'package:todolist/model/TodoModel.dart';

class TodoDetailsScreenViewModel extends ChangeNotifier {
  TodoDetailsScreenViewModel(this.model) {
    findTodo();
  }

  TodoModel model;
  String msg;

  /// Todoを１件取得する
  Future<void> findTodo() async {
    msg = "";
    await model
        .findTodo()
        .then(
          (value) => model = value,
        )
        .catchError((error) {
      return throw msg = error.toString();
    }).whenComplete(
      () => notifyListeners(),
    );
  }
}
