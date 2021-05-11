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
  TodoModel todoModel;

  @override
  Widget build(BuildContext context) {
    todoModel = widget.todoModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text("詳細"),
        actions: [
          _popupMenu(),
        ],
      ),
      body: FutureBuilder(
          future: todoModel.findTodo(),
          builder: (BuildContext context, AsyncSnapshot<TodoModel> snapshot) {
            todoModel = snapshot.data;
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _valueRow("タイトル", snapshot.data.title),
                  _valueRow("期日", snapshot.data.date),
                  _valueRow("詳細", snapshot.data.detail),
                ],
              ),
            );
          }),
    );
  }

  void didTapEditButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoRegistrationScreen(
            todoModel: widget.todoModel, mode: Mode.Edit),
      ),
    ).then((value) {
      setState(() {});
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

  Widget _popupMenu() {
    return PopupMenuButton(
      onSelected: (mode) {
        switch (mode) {
          case Mode.Edit:
            didTapEditButton();
            break;
          case Mode.Delete:
            widget.todoModel.deleteTodo();
            Navigator.of(context).pop();
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
}
