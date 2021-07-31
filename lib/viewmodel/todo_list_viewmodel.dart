import 'package:flutter/material.dart';
import 'package:todolist/model/todomodel.dart';

class TodoListViewModel extends ChangeNotifier {
  List<TodoModel> model = [];
  String message;
  final String noTodoMsg = "Todoがありません";

  TodoListViewModel() {
    allFetch();
  }

  /// 全件取得する
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

  /// 全件削除する
  Future<void> allDelete() async {
    try {
      await TodoModel().deleteALL();
      model = [];
      message = noTodoMsg;
    } catch (e) {
      message = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
