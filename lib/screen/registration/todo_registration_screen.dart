import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/other/date_format.dart';
import 'package:todolist/other/mode_enum.dart';
import 'package:todolist/screen/registration/todo_registration_viewmodel.dart';

class TodoRegistrationScreen extends StatelessWidget {
  final String createTime;
  final Mode mode;

  TodoRegistrationScreen({Key key, this.createTime = '', @required this.mode})
      : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoRegistrationViewModel>(
      create: (context) =>
          TodoRegistrationViewModel(mode, createTime: createTime),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("作成画面"),
          ),
          body: Consumer<TodoRegistrationViewModel>(
            builder: (context, viewModel, _) {
              return Container(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// タイトル
                      TextFormField(
                        controller:
                            TextEditingController(text: viewModel.title),
                        obscureText: false,
                        decoration: const InputDecoration(labelText: "タイトル"),
                        onChanged: viewModel.changeTitle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'タイトルが入力されていません';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      /// 期日
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              _selectDate(context, viewModel);
                            },
                            child: const Text("期日"),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          Text(viewModel.date),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      /// 詳細
                      TextFormField(
                          controller:
                              TextEditingController(text: viewModel.detail),
                          obscureText: false,
                          decoration: const InputDecoration(labelText: "詳細"),
                          onChanged: viewModel.changeDetail,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '詳細が入力されていません';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 10,
                      ),

                      /// 完了スイッチ
                      _completeRow(context, viewModel),
                      const SizedBox(
                        height: 20,
                      ),

                      /// 登録ボタン
                      _addTodoButton(context, viewModel)
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// 完了フラグを設定するスイッチの行を作成する
  Widget _completeRow(
      BuildContext context, TodoRegistrationViewModel viewModel) {
    if (mode == Mode.edit) {
      return Row(
        children: [
          const Text("完了"),
          Switch(
              value: viewModel.completeFlag,
              onChanged: (flag) => viewModel.changeCompleteFlag(flag)),
        ],
      );
    }
    return Container();
  }

  /// Todoの追加または、更新するボタン
  ElevatedButton _addTodoButton(
          BuildContext context, TodoRegistrationViewModel viewModel) =>
      ElevatedButton(
        onPressed: () {
          if (!viewModel.didTapAddButton(context)) {
            _formKey.currentState.validate();
          }
        },
        child: Text(mode == Mode.add ? '登録' : '更新'),
      );

  /// 日付を設定するためのPicker
  Future<void> _selectDate(
      BuildContext context, TodoRegistrationViewModel viewModel) async {
    DateTime date = DateTime.now();
    final DateTime picker = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 360)),
        currentDate: date);
    if (picker != null) {
      date = picker;
      viewModel.changeDate(Format().setFormatString(date));
    }
  }
}
