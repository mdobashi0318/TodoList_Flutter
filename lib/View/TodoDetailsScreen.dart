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
        actions: [_popupMenu()],
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
        builder: (context) => TodoRegistrationScreen(
            todoModel: widget.todoModel, mode: Mode.Edit),
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

  Widget _popupMenu() {
    return PopupMenuButton(
      onSelected: (mode) {
        switch (mode) {
          case Mode.Edit:
            didTapEditButton();
            break;
          case Mode.Delete:
            print("Todoを削除");
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
