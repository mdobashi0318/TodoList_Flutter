import 'package:flutter/material.dart';
import 'package:todolist/TodoModel.dart';

class TodoRegistrationScreen extends StatefulWidget {
  TodoRegistrationScreen({Key key}) : super(key: key);

  @override
  _TodoRegistrationScreen createState() => _TodoRegistrationScreen();
}

class _TodoRegistrationScreen extends State<TodoRegistrationScreen> {
  String _title = "";
  String _date = "";
  String _detail = "";

  @override
  Widget build(BuildContext context) {
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
              obscureText: false,
              decoration: InputDecoration(labelText: "タイトル"),
              onChanged: _changeTitle,
            ),
            TextField(
              obscureText: false,
              decoration: InputDecoration(labelText: "期限"),
              onChanged: _changeDate,
            ),
            TextField(
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
          TodoModel(title: _title, date: _date, detail: _detail, createTime: "")
              .insertTodo();
          Navigator.of(context).pop();
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
}
