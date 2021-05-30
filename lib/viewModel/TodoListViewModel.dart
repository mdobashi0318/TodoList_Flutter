import 'package:flutter/material.dart';
import 'package:todolist/model/TodoModel.dart';

class TodoListViewModel extends ChangeNotifier {
  List<TodoModel> model = [];

  TodoListViewModel() {
    allFetch();
  }

  Future<void> allFetch() async {
    await TodoModel().findAllTodo().then((value) {
      value.sort((a, b) {
        return a.date.compareTo(b.date);
      });
      model = value;
    });
    notifyListeners();
  }

  Future<void> allDelete() async {
    await TodoModel().deleteALL().then((_) => model = []);
    notifyListeners();
  }
}
