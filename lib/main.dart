import 'package:flutter/material.dart';
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
        title: Text("TodoList"),
      ),
      body: FutureBuilder(
          future: TodoModel().getTodos(),
          builder:
              (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
            if (snapshot.data.length > 0) {
              return TodoList(
                todoModel: snapshot.data,
              );
            } else {
              return Text("Todoがありません");
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TodoRegistrationScreen(),
                fullscreenDialog: true),
          );
        },
      ),
    );
  }
}
