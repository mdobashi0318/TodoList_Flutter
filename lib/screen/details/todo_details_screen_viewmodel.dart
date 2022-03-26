import 'package:flutter/material.dart';
import 'package:todolist/model/todo_model.dart';


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
        .find(model.createTime)
        .then(
          (value) => model = value,
        )
        .catchError((dynamic error) {
      return throw msg = error.toString();
    }).whenComplete(
      () => notifyListeners(),
    );
  }
}
