import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/model/todo_model.dart';
import 'package:todolist/other/complete_enum.dart';
import 'package:todolist/other/mode_enum.dart';
import 'package:todolist/view/todo_registration_screen.dart';
import 'package:todolist/viewModel/todo_details_screen_viewmodel.dart';

/// Todoの詳細画面
class TodoDetailsScreen extends StatefulWidget {
  final TodoModel todoModel;

  const TodoDetailsScreen({Key key, this.todoModel}) : super(key: key);

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
          builder: (context, _) {
            if (viewModel.msg.isNotEmpty) {
              Future.delayed(const Duration(seconds: 1), () {
                _errorSnackBar(context, viewModel.msg);
              });
            }
            return Column(
              children: [
                Consumer<TodoDetailsScreenViewModel>(builder:
                    (context, value, child) {
                  return _valueRow('タイトル', value.model.title);
                }),
                Consumer<TodoDetailsScreenViewModel>(builder:
                    (context, value, child) {
                  return _valueRow("期日", value.model.date);
                }),
                Consumer<TodoDetailsScreenViewModel>(builder:
                    (context, value, child) {
                  return _valueRow("詳細", value.model.detail);
                }),
                Consumer<TodoDetailsScreenViewModel>(builder:
                    (context, value, child) {
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
    Navigator.push<void>(
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
        style: const TextStyle(fontSize: 13),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  /// 「編集」「削除」ボタンをセットしたメニューを表示する
  Widget _popupMenu() {
    return PopupMenuButton(
      onSelected: (dynamic mode) {
        switch (mode as Mode) {
          case Mode.Edit:
            didTapEditButton();
            break;
          case Mode.Delete:
            _showAlert(context);
            break;
          case Mode.Add:
            break;
        }
      },
      itemBuilder: (context) {
        return <PopupMenuEntry<Mode>>[
          const PopupMenuItem(value: Mode.Edit, child: Text("編集")),
          const PopupMenuItem(value: Mode.Delete, child: Text("削除"))
        ];
      },
    );
  }

  /// Todoの削除時のアラートを表示する
  Future<void> _showAlert(BuildContext contex) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Todoを削除しますか？"),
          actions: <Widget>[
            SimpleDialogOption(
              child: const Text("削除"),
              onPressed: () async {
                await viewModel.model
                    .deleteTodo()
                    .then((value) => Navigator.of(context).pop());
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text("キャンセル"),
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
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
