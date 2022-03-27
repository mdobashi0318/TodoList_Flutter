import 'package:flutter/material.dart';
import 'package:todolist/model/todo_model.dart';
import 'package:todolist/other/complete_enum.dart';
import 'package:todolist/preferences/first_preferences.dart';
import 'package:todolist/screen/widgets/common_dialog.dart';

class TodoListViewModel extends ChangeNotifier with CommonDialog {
  List<TodoModel> model = [];
  List<TodoModel> unfinishedModel = [];
  List<TodoModel> completionModel = [];
  String message;
  String noTodoMsg = "Todoがありません";

  TodoListViewModel() {
    fetchModels();
  }

  Future<void> fetchModels() async {
    await FirstPreferences().getFirstCreateTodo().then((value) { noTodoMsg = value ? "Todoがありません" : '「+」ボタンから最初のTodoを作成しましょう';});
    await _allFetch();
    await _unfinishedFetch();
    await _completionFetch();
    notifyListeners();
  }

  /// 全件取得する
  Future<void> _allFetch() async {
    message = "";
    await TodoModel().allFind().then((value) {
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
    await TodoModel().allFind().then((value) {
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
    await TodoModel().allFind().then((value) {
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
  Future<void> allDelete(BuildContext context) async {
    showConfirmAlert(
      context,
      "Todoを全件削除しますか？",
      '削除',
      () async {
        try {
          await TodoModel().allDelete();
          model = [];
          unfinishedModel = [];
          completionModel = [];
          message = noTodoMsg;
          Navigator.pop(context);
          notifyListeners();
        } catch (e) {
          displaySnackBar(context, e.toString());
        }
      },
      "キャンセル",
      () => Navigator.pop(context),
    );
  }
}
