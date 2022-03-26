import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/model/todo_model.dart';
import 'package:todolist/other/complete_enum.dart';
import 'package:todolist/other/mode_enum.dart';
import 'package:todolist/screen/registration/todo_registration_screen.dart';

import 'todo_details_viewmodel.dart';

/// Todoの詳細画面
// ignore: must_be_immutable
class TodoDetailsScreen extends StatelessWidget {
  TodoDetailsScreen({Key key}) : super(key: key);

  TodoDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = TodoDetailsViewModel(
        ModalRoute.of(context).settings.arguments as TodoModel);

    if (viewModel.msg.isNotEmpty) {
      Future.delayed(const Duration(seconds: 1), () {
        viewModel.errorSnackBar(context, viewModel.msg);
      });
    }
    return ChangeNotifierProvider<TodoDetailsViewModel>(
        create: (context) => viewModel,
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("詳細"),
              actions: [
                _popupMenu(context),
              ],
            ),
            body: Consumer<TodoDetailsViewModel>(
              builder: (context, viewModel, _) {
                return Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      _valueRow('タイトル', viewModel.model.title),
                      _valueRow("期日", viewModel.model.date),
                      _valueRow("詳細", viewModel.model.detail),
                      _valueRow(
                          "実施状況",
                          viewModel.model.completeFlag ==
                                  CompleteFlag.unfinished
                              ? "未実施"
                              : "完了"),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  /// 編集画面を表示する
  void didTapEditButton(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => TodoRegistrationScreen(
            createTime: viewModel.model.createTime, mode: Mode.edit),
      ),
    ).then((value) {
      viewModel.findTodo();
    });
  }

  /// 行のタイトルと値をセットする
  Widget _valueRow(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 13),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  /// 「編集」「削除」ボタンをセットしたメニューを表示する
  Widget _popupMenu(BuildContext context) {
    return PopupMenuButton(
      onSelected: (dynamic mode) {
        switch (mode as Mode) {
          case Mode.edit:
            didTapEditButton(context);
            break;
          case Mode.delete:
            viewModel.deleteTodo(context);
            break;
          case Mode.add:
            break;
        }
      },
      itemBuilder: (context) {
        return <PopupMenuEntry<Mode>>[
          const PopupMenuItem(value: Mode.edit, child: Text("編集")),
          const PopupMenuItem(value: Mode.delete, child: Text("削除"))
        ];
      },
    );
  }
}
