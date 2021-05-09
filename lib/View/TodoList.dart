import 'package:flutter/material.dart';
import 'package:todolist/model/TodoModel.dart';
import 'package:todolist/view/TodoDetailsScreen.dart';
import 'package:todolist/view/TodoRow.dart';

class TodoList extends StatefulWidget {
  TodoList({Key key}) : super(key: key);
  @override
  _TodoList createState() => _TodoList();
}

class _TodoList extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TodoModel().getTodos(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return TodoRow(
                    todoModel: snapshot.data[index],
                    onTap: () {
                      didTapTodoRow(
                        snapshot.data[index],
                      );
                    },
                  );
                });
          } else {
            return Text("Todoがありません");
          }
        });
  }

  void didTapTodoRow(TodoModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoDetailsScreen(todoModel: model),
      ),
    ).then((value) => setState(() {}));
  }
}
