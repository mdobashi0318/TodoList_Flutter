import 'package:flutter/material.dart';
import 'package:todolist/other/Mode.dart';
import 'package:todolist/view/TodoList.dart';
import 'package:todolist/model/TodoModel.dart';
import 'package:todolist/view/TodoRegistrationScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoList"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showAlert(context),
          ),
        ],
      ),
      body: TodoList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TodoRegistrationScreen(mode: Mode.Add),
                fullscreenDialog: true),
          ).then((value) {
            setState(() {});
          });
        },
      ),
    );
  }

  void _showAlert(BuildContext contex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Todoを全件削除しますか？"),
          actions: <Widget>[
            SimpleDialogOption(
              child: Text("削除"),
              onPressed: () {
                TodoModel().deleteALL().then((value) => setState(() {
                      Navigator.pop(context);
                    }));
              },
            ),
            SimpleDialogOption(
              child: Text("キャンセル"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
