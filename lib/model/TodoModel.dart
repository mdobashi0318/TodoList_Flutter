import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todolist/Other/Format.dart';

class TodoModel {
  final String _tableName = "todo";

  /// タイトル
  String title;

  /// 期日
  String date;

  /// 詳細
  String detail;

  /// 作成時間(プライマリキー)
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
    final _createTime = createTime == null ? Format().createTime : createTime;
    return {
      "createTime": _createTime,
      "title": title,
      "date": date,
      "detail": detail,
    };
  }

  /// Todoの作成
  Future<void> addTodo() async {
    final Database db = await database;

    print("Todoを作成: ${this.toMap()}");
    await db
        .insert(
      _tableName,
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .onError((error, stackTrace) {
      print("stackTrace: $stackTrace");
      print("Error: $error");
      return throw ("Todoの追加に失敗しました");
    });
  }

  /// Todoの更新
  Future<void> updateTodo() async {
    final Database db = await database;
    await db
        .update(
      _tableName,
      this.toMap(),
      where: "createTime = ?",
      whereArgs: [createTime],
      conflictAlgorithm: ConflictAlgorithm.fail,
    )
        .onError((error, stackTrace) {
      print("stackTrace: $stackTrace");
      print("Error: $error");
      return throw ("Todoの更新に失敗しました");
    });
  }

  /// Todoの全件取得
  Future<List<TodoModel>> findAllTodo() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(_tableName).onError((error, stackTrace) {
      print("stackTrace: $stackTrace");
      print("Todoの全件取得エラー: $error");
      return throw ("Todoの取得に失敗しました");
    });
    return List.generate(maps.length, (i) {
      return TodoModel(
        title: maps[i]['title'],
        date: maps[i]['date'],
        detail: maps[i]['detail'],
        createTime: maps[i]['createTime'],
      );
    });
  }

  /// Todoの1件取得
  Future<TodoModel> findTodo() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "createTime = ?",
      whereArgs: [createTime],
    ).onError((error, stackTrace) {
      print("stackTrace: $stackTrace");
      print("Todoの取得エラー: $error");
      return throw ("Todoの取得に失敗しました");
    });

    return List.generate(maps.length, (i) {
      return TodoModel(
        title: maps[i]['title'],
        date: maps[i]['date'],
        detail: maps[i]['detail'],
        createTime: maps[i]['createTime'],
      );
    }).first;
  }

  /// Todoの全件削除
  Future<void> deleteALL() async {
    final Database db = await database;
    db.delete(_tableName).onError((error, stackTrace) {
      print("stackTrace: $stackTrace");
      print("Todoの全件削除エラー: $error");
      return throw ("Todoの削除に失敗しました");
    });
  }

  /// Todoを一件削除
  Future<void> deleteTodo() async {
    final Database db = await database;

    db.delete(
      _tableName,
      where: "createTime = ?",
      whereArgs: [createTime],
    ).onError((error, stackTrace) {
      print("stackTrace: $stackTrace");
      print("Todoの削除エラー: $error");
      return throw ("Todoの削除に失敗しました");
    });
  }
}
