import 'package:flutter/material.dart';
import 'package:todolist/model/TodoModel.dart';

enum Mode { Add, Edit }

class TodoRegistrationScreen extends StatefulWidget {
  final TodoModel todoModel;
  final Mode mode;

  TodoRegistrationScreen({Key key, this.todoModel, this.mode})
      : super(key: key);

  @override
  _TodoRegistrationScreen createState() => _TodoRegistrationScreen();
}

class _TodoRegistrationScreen extends State<TodoRegistrationScreen> {
  String _title = "";
  String _date = "";
  String _detail = "";

  @override
  Widget build(BuildContext context) {
    if (widget.mode == Mode.Edit) {
      _title = widget.todoModel.title;
      _date = widget.todoModel.date;
      _detail = widget.todoModel.detail;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("作成画面"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: _title),
              obscureText: false,
              decoration: InputDecoration(labelText: "タイトル"),
              onChanged: _changeTitle,
            ),
            TextField(
              controller: TextEditingController(text: _date),
              obscureText: false,
              decoration: InputDecoration(labelText: "期限"),
              onChanged: _changeDate,
            ),
            TextField(
              controller: TextEditingController(text: _detail),
              obscureText: false,
              decoration: InputDecoration(labelText: "詳細"),
              onChanged: _changeDetail,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (_title.isEmpty || _date.isEmpty || _detail.isEmpty) {
            _showAlert(context);
          } else {
            switch (widget.mode) {
              case Mode.Add:
                TodoModel(title: _title, date: _date, detail: _detail)
                    .insertTodo();
                break;
              case Mode.Edit:
                print("編集");
                break;
            }
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  void _changeTitle(String text) {
    _title = text;
  }

  void _changeDate(String text) {
    _date = text;
  }

  void _changeDetail(String text) {
    _detail = text;
  }

  void _showAlert(BuildContext contex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("入力されていない項目があります"),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("閉じる"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
