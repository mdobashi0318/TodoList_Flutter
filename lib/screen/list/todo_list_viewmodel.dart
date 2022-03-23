import 'package:flutter/material.dart';
import 'package:todolist/model/todo_model.dart';
import 'package:todolist/other/complete_enum.dart';

class TodoListViewModel extends ChangeNotifier {
  List<TodoModel> model = [];
  List<TodoModel> unfinishedModel = [];
  List<TodoModel> completionModel = [];
  String message;
  final String noTodoMsg = "Todoがありません";

  TodoListViewModel() {
    fetchModels();
  }

  Future<void> fetchModels() async {
    await _allFetch();
    await _unfinishedFetch();
    await _completionFetch();
    notifyListeners();
  }

  /// 全件取得する
  Future<void> _allFetch() async {
    message = "";
    await TodoModel().findAllTodo().then((value) {
      value.sort((a, b) {
        return a.date.compareTo(b.date);
      });
      model = value;
      if (value.isEmpty) {
        message = noTodoMsg;
      }
    }).catchError((dynamic error) {
      message = error as String;
    });
  }

  /// 未完了のTodoを取り出す
  Future<void> _unfinishedFetch() async {
    message = "";
    await TodoModel().findAllTodo().then((value) {
      unfinishedModel = value
          .where((element) =>
              element.completeFlag.toString() ==
              CompleteFlag.unfinished.toString())
          .toList();
      unfinishedModel.sort((a, b) {
        return a.date.compareTo(b.date);
      });
      if (value.isEmpty) {
        message = noTodoMsg;
      }
    }).catchError((dynamic error) {
      message = error as String;
    });
  }

  /// 完了したTodoを取り出す
  Future<void> _completionFetch() async {
    message = "";
    await TodoModel().findAllTodo().then((value) {
      completionModel = value
          .where((element) => element.completeFlag == CompleteFlag.completion)
          .toList();
      value.sort((a, b) {
        return a.date.compareTo(b.date);
      });
      if (value.isEmpty) {
        message = noTodoMsg;
      }
    }).catchError((dynamic error) {
      message = error as String;
    });
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
