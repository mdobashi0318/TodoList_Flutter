import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  void initState() {
    super.initState();
    todoModel = widget.todoModel;
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
      body: FutureBuilder(
          future: todoModel.findTodo(),
          builder: (BuildContext context, AsyncSnapshot<TodoModel> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                todoModel = snapshot.data;
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Provider<String>.value(
                        value: snapshot.data.title,
                        child:
                            Consumer(builder: (context, String value, child) {
                          return _valueRow("タイトル", value);
                        }),
                      ),
                      Provider<String>.value(
                        value: snapshot.data.date,
                        child:
                            Consumer(builder: (context, String value, child) {
                          return _valueRow("期日", value);
                        }),
                      ),
                      Provider<String>.value(
                        value: snapshot.data.detail,
                        child:
                            Consumer(builder: (context, String value, child) {
                          return _valueRow("詳細", value);
                        }),
                      ),
                    ],
                  ),
                );
              case ConnectionState.waiting:
              case ConnectionState.none:
              case ConnectionState.active:
            }
            return Container();
          }),
    );
  }

  void didTapEditButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TodoRegistrationScreen(todoModel: todoModel, mode: Mode.Edit),
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
            todoModel.deleteTodo();
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
