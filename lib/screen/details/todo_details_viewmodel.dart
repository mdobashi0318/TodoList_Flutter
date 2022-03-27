import 'package:flutter/material.dart';
import 'package:todolist/model/todo_model.dart';
import 'package:todolist/screen/widgets/common_dialog.dart';

class TodoDetailsViewModel extends ChangeNotifier with CommonDialog {
  TodoDetailsViewModel(this.model) {
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

  /// Todoの削除時のアラートを表示する
  Future<void> deleteTodo(BuildContext context) async {
    showConfirmAlert(
      context,
      "Todoを削除しますか？",
      '削除',
      () async {
        await model
            .delete(model.createTime)
            .then((value) => Navigator.of(context).pop());
        Navigator.of(context).pop();
      },
      'キャンセル',
      () => Navigator.of(context).pop(),
    );
  }
}
