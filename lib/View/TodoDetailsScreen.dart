import 'package:flutter/material.dart';
import 'package:todolist/model/TodoModel.dart';
import 'package:todolist/view/TodoRegistrationScreen.dart';

class TodoDetailsScreen extends StatefulWidget {
  final TodoModel todoModel;

  TodoDetailsScreen({Key key, this.todoModel}) : super(key: key);

  @override
  _TodoDetailsScreen createState() => _TodoDetailsScreen();
}

class _TodoDetailsScreen extends State<TodoDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("詳細"),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                didTapEditButton();
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            _valueRow("タイトル", widget.todoModel.title),
            _valueRow("期限", widget.todoModel.date),
            _valueRow("詳細", widget.todoModel.detail),
          ],
        ),
      ),
    );
  }

  void didTapEditButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoRegistrationScreen(todoModel: widget.todoModel,mode: Mode.Edit),
      ),
    ).then((value) {
      setState(() {
        print("戻った");
      });
    });
  }

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
}
