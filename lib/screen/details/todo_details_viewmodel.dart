import 'package:flutter/material.dart';
import 'package:todolist/model/todo_model.dart';
import 'package:todolist/other/complete_enum.dart';
import 'package:todolist/screen/widgets/common_dialog.dart';

class TodoDetailsViewModel extends ChangeNotifier with CommonDialog {
  TodoDetailsViewModel(this._model) {
    findTodo();
  }

  TodoModel _model;

  TodoModel get getModel => _model;

  /// 完了状態を取得する
  bool get isUnfinishedFlag => getModel.completeFlag == CompleteFlag.unfinished;

  String msg;

  /// Todoを１件取得する
  Future<void> findTodo() async {
    msg = "";
    await _model
        .find(_model.createTime)
        .then(
          (value) => _model = value,
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
        await _model
            .delete(_model.createTime)
            .then((value) => Navigator.of(context).pop());
        Navigator.of(context).pop();
      },
      'キャンセル',
      () => Navigator.of(context).pop(),
    );
  }
}
