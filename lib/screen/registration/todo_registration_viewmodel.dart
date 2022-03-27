import 'package:flutter/material.dart';
import 'package:todolist/model/todo_model.dart';
import 'package:todolist/other/complete_enum.dart';
import 'package:todolist/other/mode_enum.dart';
import 'package:todolist/screen/widgets/common_dialog.dart';

class TodoRegistrationViewModel extends ChangeNotifier with CommonDialog {
  TodoRegistrationViewModel(this._mode, {String createTime}) {
    if (_mode == Mode.edit) {
      TodoModel()
          .find(createTime)
          .then((value) => _model = value)
          .whenComplete(() {
        changeTitle(_model.title);
        changeDetail(_model.detail);
        changeDate(_model.date);
        changeCompleteFlag(
            _model.completeFlag.index == CompleteFlag.unfinished.index
                ? false
                : true);
      });
    }
  }

  final Mode _mode;

  TodoModel _model;

  /// タイトル
  String title = "";

  /// 日付
  String date = "";

  /// 詳細
  String detail = "";

  /// 完了フラグ
  bool completeFlag = false;

  void changeTitle(String text) {
    title = text;
  }

  void changeDetail(String text) {
    detail = text;
  }

  void changeDate(String text) {
    date = text;
    notifyListeners();
  }

  void changeCompleteFlag(bool flag) {
    completeFlag = flag;
    notifyListeners();
  }

  bool didTapAddButton(BuildContext context) {
    if (title.isEmpty || date.isEmpty || detail.isEmpty) {
      showAlert(context, "入力されていない項目があります");
      return false;
    } else {
      _addTodo(context);
      return true;
    }
  }

  /// modeによってtodoを追加する、または更新する
  Future<void> _addTodo(BuildContext context) async {
    switch (_mode) {
      case Mode.add:
        TodoModel(
          title: title,
          date: date,
          detail: detail,
          completeFlag: completeFlag == false
              ? CompleteFlag.unfinished
              : CompleteFlag.completion,
        )
            .add()
            .then(
              /// 前画面に戻った時に、Todoを再取得をさせるために「Mode.add」のキーワードを渡す
              (_) => Navigator.of(context).pop<Mode>(Mode.add),
            )
            .catchError(
              (dynamic error) => displaySnackBar(
                context,
                error.toString(),
              ),
            );
        break;
      case Mode.edit:
        TodoModel(
          title: title,
          date: date,
          detail: detail,
          createTime: _model.createTime,
          completeFlag: completeFlag == false
              ? CompleteFlag.unfinished
              : CompleteFlag.completion,
        )
            .update(_model.createTime)
            .then((value) => Navigator.of(context).pop())
            .catchError((dynamic error) => displaySnackBar(
                  context,
                  error.toString(),
                ));
        break;
      case Mode.delete:
        break;
    }
  }
}
