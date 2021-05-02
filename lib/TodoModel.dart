import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class TodoModel {
  String title;
  String date;
  String detail;
  String createTime;

  TodoModel({this.title, this.date, this.detail, this.createTime});

  final Future<Database> database = openDatabase(
    join('TodoModel.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE todo(createTime TEXT PRIMARY KEY, title TEXT, date TEXT, detail TEXT)",
      );
    },
    version: 1,
  );

  Map<String, dynamic> toMap() {
    return {
      "createTime": createTime,
      "title": title,
      "date": date,
      "detail": detail,
    };
  }

  Future<void> insertTodo() async {
    final Database db = await database;
    await db.insert(
      'todo',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TodoModel>> getTodos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todo');
    return List.generate(maps.length, (i) {
      return TodoModel(
        title: maps[i]['title'],
        date: maps[i]['date'],
        detail: maps[i]['detail'],
        createTime: maps[i]['createTime'],
      );
    });
  }
}
