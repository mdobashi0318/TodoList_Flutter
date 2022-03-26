import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



import 'model/todo_model.dart';
import 'other/mode_enum.dart';
import 'screen/details/todo_details_screen.dart';
import 'screen/list/todo_list.dart';
import 'screen/list/todo_list_viewmodel.dart';
import 'screen/registration/todo_registration_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/detail': (context) => TodoDetailsScreen(todoModel: TodoModel()),
      },
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TodoListViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = TodoListViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoListViewModel>(
      create: (context) => viewModel,
      child: Consumer<TodoListViewModel>(
        builder: (context, viewModel, _) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("TodoList"),
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      text: '全件',
                    ),
                    Tab(
                      text: '未完了',
                    ),
                    Tab(
                      text: '完了',
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showAlert(context),
                  ),
                ],
              ),
              body: TabBarView(children: [
                TodoList(
                  model: viewModel.model,
                  viewModel: viewModel,
                ),
                TodoList(
                  model: viewModel.unfinishedModel,
                  viewModel: viewModel,
                ),
                TodoList(
                  model: viewModel.completionModel,
                  viewModel: viewModel,
                )
              ]),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const TodoRegistrationScreen(mode: Mode.add),
                        fullscreenDialog: true),
                  ).then((dynamic value) {
                    if (value == "0") viewModel.fetchModels();
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showAlert(BuildContext contex) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Todoを全件削除しますか？"),
          actions: <Widget>[
            SimpleDialogOption(
              child: const Text("削除"),
              onPressed: () async {
                await viewModel
                    .allDelete()
                    .catchError(
                        (dynamic error) => _errorSnackBar(error.toString()))
                    .whenComplete(() => Navigator.pop(context));
              },
            ),
            SimpleDialogOption(
              child: const Text("キャンセル"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _errorSnackBar(String error) {
    SnackBar snackBar = SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
