import 'package:flutter/material.dart';

class TodoDetailsScreen extends StatefulWidget {
  TodoDetailsScreen({Key key}) : super(key: key);

  @override
  _TodoDetailsScreen createState() => _TodoDetailsScreen();
}

class _TodoDetailsScreen extends State<TodoDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("詳細"),
      ),
      body: Text("詳細画面"),
    );
  }
}
