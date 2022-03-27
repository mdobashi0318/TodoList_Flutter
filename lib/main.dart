import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/screen/widgets/error_dialog.dart';

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
        '/detail': (context) => TodoDetailsScreen(),
      },
      home: const MainTabsScreen(),
    );
  }
}

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({Key key}) : super(key: key);

  @override
  _MainTabsScreenState createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> with ErrorDialog {
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
                    Tab(text: '全件'),
                    Tab(text: '未完了'),
                    Tab(text: '完了'),
                  ],
                ),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => viewModel.allDelete(context)),
                ],
              ),
              body: TabBarView(children: [
                TodoList(
                  model: viewModel.model,
                  viewModel: viewModel,
                ),
                TodoList(
                    model: viewModel.unfinishedModel, viewModel: viewModel),
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
                            TodoRegistrationScreen(mode: Mode.add),
                        fullscreenDialog: true),
                  ).then((dynamic value) {
                    /// todoを追加して戻った場合にはTodoの再取得を行う
                    if (value == Mode.add) viewModel.fetchModels();
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
