import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/model/TodoModel.dart';
import 'package:todolist/other/CompleteFlag.dart';
import 'package:todolist/other/Mode.dart';
import 'package:todolist/view/TodoRegistrationScreen.dart';
import 'package:todolist/viewModel/TodoDetailsScreenViewModel.dart';

/// Todoの詳細画面
class TodoDetailsScreen extends StatefulWidget {
  final TodoModel todoModel;

  TodoDetailsScreen({Key key, this.todoModel}) : super(key: key);

  @override
  _TodoDetailsScreen createState() => _TodoDetailsScreen();
}

class _TodoDetailsScreen extends State<TodoDetailsScreen> {
  TodoDetailsScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = TodoDetailsScreenViewModel(widget.todoModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("詳細"),
        actions: [
          _popupMenu(),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ChangeNotifierProvider<TodoDetailsScreenViewModel>(
          create: (context) => viewModel,
          builder: (BuildContext context, _) {
            if (viewModel.msg.isNotEmpty) {
              Future.delayed(Duration(seconds: 1), () {
                _errorSnackBar(context, viewModel.msg);
              });
            }
            return Column(
              children: [
                Consumer(builder:
                    (context, TodoDetailsScreenViewModel value, child) {
                  return _valueRow("タイトル", value.model.title);
                }),
                Consumer(builder:
                    (context, TodoDetailsScreenViewModel value, child) {
                  return _valueRow("期日", value.model.date);
                }),
                Consumer(builder:
                    (context, TodoDetailsScreenViewModel value, child) {
                  return _valueRow("詳細", value.model.detail);
                }),
                Consumer(builder:
                    (context, TodoDetailsScreenViewModel value, child) {
                  return _valueRow(
                      "実施状況",
                      value.model.completeFlag == CompleteFlag.unfinished
                          ? "未実施"
                          : "完了");
                })
              ],
            );
          },
        ),
      ),
    );
  }

  /// 編集画面を表示する
  void didTapEditButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TodoRegistrationScreen(todoModel: viewModel.model, mode: Mode.Edit),
      ),
    ).then((value) {
      viewModel.findTodo();
    });
  }

  /// 行のタイトルと値をセットする
  Widget _valueRow(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 13),
      ),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  /// 「編集」「削除」ボタンをセットしたメニューを表示する
  Widget _popupMenu() {
    return PopupMenuButton(
      onSelected: (mode) {
        switch (mode) {
          case Mode.Edit:
            didTapEditButton();
            break;
          case Mode.Delete:
            _showAlert(context);
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<Mode>>[
          PopupMenuItem(value: Mode.Edit, child: Text("編集")),
          PopupMenuItem(value: Mode.Delete, child: Text("削除"))
        ];
      },
    );
  }

  /// Todoの削除時のアラートを表示する
  Future<void> _showAlert(BuildContext contex) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Todoを削除しますか？"),
          actions: <Widget>[
            SimpleDialogOption(
              child: Text("削除"),
              onPressed: () async {
                await viewModel.model
                    .deleteTodo()
                    .then((value) => Navigator.of(context).pop());
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text("キャンセル"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  /// SnackBarを表示する
  void _errorSnackBar(BuildContext context, String error) {
    SnackBar snackBar = SnackBar(
      content: Text(error),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
