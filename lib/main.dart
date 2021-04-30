import 'package:flutter/material.dart';
import 'package:todolist/TodoList.dart';
import 'package:todolist/TodoRegistrationScreen.dart';

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
      body: TodoList(
        todoModel: [
          TodoModel("title1", "date1", "detail1"),
          TodoModel("title2", "date2", "detail2"),
          TodoModel("title3", "date3", "detail3"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TodoRegistrationScreen(),
                  fullscreenDialog: true));
        },
      ),
    );
  }
}
