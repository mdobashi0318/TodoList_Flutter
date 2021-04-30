import 'package:flutter/material.dart';

class TodoRegistrationScreen extends StatefulWidget {
  TodoRegistrationScreen({Key key}) : super(key: key);

  @override
  _TodoRegistrationScreen createState() => _TodoRegistrationScreen();
}

class _TodoRegistrationScreen extends State<TodoRegistrationScreen> {
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
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "期限"),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "詳細"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print("Todoを追加");
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
