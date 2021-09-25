import 'package:flutter/material.dart';
import 'package:todolist/model/todo_model.dart';
import 'package:todolist/other/complete_enum.dart';
import 'package:todolist/other/format.dart';
import 'package:todolist/other/mode_enum.dart';

class TodoRegistrationScreen extends StatefulWidget {
  final TodoModel todoModel;
  final Mode mode;

  const TodoRegistrationScreen({Key key, this.todoModel, @required this.mode})
      : super(key: key);

  @override
  _TodoRegistrationScreen createState() => _TodoRegistrationScreen();
}

class _TodoRegistrationScreen extends State<TodoRegistrationScreen> {
  /// タイトル
  String _title = "";

  /// 日付
  String _date = "";

  /// 詳細
  String _detail = "";

  /// 完了フラグ
  bool _completeFlag = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.mode == Mode.Edit) {
      _title = widget.todoModel.title;
      _date = widget.todoModel.date;
      _detail = widget.todoModel.detail;
      _completeFlag =
          widget.todoModel.completeFlag.index == CompleteFlag.unfinished.index
              ? false
              : true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("作成画面"),
        actions: [
          _addTodoButton(),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: TextEditingController(text: _title),
                obscureText: false,
                decoration: const InputDecoration(labelText: "タイトル"),
                onChanged: _changeTitle,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'タイトルが入力されていません';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _selectDate();
                    },
                    child: const Text("期日"),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Text(_date),
                ],
              ),
              TextFormField(
                  controller: TextEditingController(text: _detail),
                  obscureText: false,
                  decoration: const InputDecoration(labelText: "詳細"),
                  onChanged: _changeDetail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '詳細が入力されていません';
                    }
                    return null;
                  }),
              _completeRow(),
            ],
          ),
        ),
      ),
    );
  }

  void _changeTitle(String text) {
    _title = text;
  }

  void _changeDetail(String text) {
    _detail = text;
  }

  void _changeCompleteFlag(bool flag) {
    setState(() {
      _completeFlag = flag;
    });
  }

  /// 完了フラグを設定するスイッチの行を作成する
  Widget _completeRow() {
    if (widget.mode == Mode.Edit) {
      return Row(
        children: [
          const Text("完了"),
          Switch(
              value: _completeFlag,
              onChanged: (flag) => _changeCompleteFlag(flag)),
        ],
      );
    }
    return Container();
  }

  /// Todoの追加または、更新するボタン
  IconButton _addTodoButton() => IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          if (_title.isEmpty || _date.isEmpty || _detail.isEmpty) {
            _showAlert(context);
            _formKey.currentState.validate();
          } else {
            switch (widget.mode) {
              case Mode.Add:
                TodoModel(
                  title: _title,
                  date: _date,
                  detail: _detail,
                  completeFlag: _completeFlag == false
                      ? CompleteFlag.unfinished
                      : CompleteFlag.completion,
                )
                    .addTodo()
                    .then((_) => Navigator.of(context).pop<String>("0"))
                    .catchError((dynamic error) => _errorSnackBar(error.toString()));
                break;
              case Mode.Edit:
                TodoModel(
                  title: _title,
                  date: _date,
                  detail: _detail,
                  createTime: widget.todoModel.createTime,
                  completeFlag: _completeFlag == false
                      ? CompleteFlag.unfinished
                      : CompleteFlag.completion,
                )
                    .updateTodo()
                    .then((value) => Navigator.of(context).pop())
                    .catchError((dynamic error) => _errorSnackBar(error.toString()));
                break;
              case Mode.Delete:
                break;
            }
          }
        },
      );

  /// 未入力があったときににダイアログを表示させる
  Future<void> _showAlert(BuildContext contex) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("入力されていない項目があります"),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text("閉じる"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  /// 日付を設定するためのPicker
  Future<void> _selectDate() async {
    DateTime date = DateTime.now();
    final DateTime picker = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 360)),
        currentDate: date);
    if (picker != null) {
      setState(() {
        date = picker;
        _date = Format().setFormatString(date);
      });
    }
  }

  /// SnackBarを表示する
  void _errorSnackBar(String error) {
    SnackBar snackBar = SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
