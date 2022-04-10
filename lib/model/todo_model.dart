import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todolist/other/complete_enum.dart';
import 'package:todolist/other/date_format.dart';
import 'package:todolist/preferences/first_preferences.dart';

import 'base_model.dart';

class TodoModel implements BaseModel<TodoModel> {
  @override
  String tableName = 'todo';

  @override
  Future<Database> database;

  /// タイトル
  String title;

  /// 期日
  String date;

  /// 詳細
  String detail;

  /// 完了フラグ
  CompleteFlag completeFlag;

  /// 作成時間(プライマリキー)
  String createTime;

  TodoModel({
    this.title,
    this.date,
    this.detail,
    this.createTime,
    this.completeFlag,
  }) {
    database = openDatabase(
      join('TodoModel.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $tableName(createTime TEXT PRIMARY KEY, title TEXT, date TEXT, detail TEXT, completeFlag Text)",
        );
      },
      version: 1,
    );
  }

  Map<String, dynamic> toMap() {
    final _createTime = createTime ?? Format().createTime;
    return <String, String>{
      "createTime": _createTime,
      "title": title,
      "date": date,
      "detail": detail,
      "completeFlag": completeFlag == CompleteFlag.unfinished ? "0" : "1",
    };
  }

  /// Todoの作成
  @override
  Future<void> add() async {
    final Database db = await database;
    try {
      await db.insert(
        tableName,
        toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      log('Todo追加: title: $title, date: $date, detail: $detail');
      await FirstPreferences().saveFirstCreateTodo();
    } catch (e, s) {
      log("Error: $e");

      log("stackTrace: $s");
      return throw ("Todoの追加に失敗しました");
    }
  }

  /// Todoの更新
  @override
  Future<void> update(String key) async {
    try {
      final Database db = await database;
      await db.update(
        tableName,
        toMap(),
        where: "createTime = ?",
        whereArgs: [key],
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      log('Todo更新: title: $title, date: $date, detail: $detail, completeFlag: $completeFlag, createTime: $createTime');
    } catch (e, s) {
      log("Error: $e");

      log("stackTrace: $s");
      return throw ("Todoの更新に失敗しました");
    }
  }

  /// Todoの全件取得
  @override
  Future<List<TodoModel>> allFind() async {
    final Database db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(tableName);
      return List.generate(maps.length, (i) {
        return TodoModel(
          title: maps[i]['title'] as String,
          date: maps[i]['date'] as String,
          detail: maps[i]['detail'] as String,
          createTime: maps[i]['createTime'] as String,
          completeFlag: maps[i]['completeFlag'] == "0"
              ? CompleteFlag.unfinished
              : CompleteFlag.completion,
        );
      });
    } catch (e, s) {
      log("error: $e");

      log("stackTrace: $s");
      return throw ("Todoの取得に失敗しました");
    }
  }

  /// Todoの1件取得
  @override
  Future<TodoModel> find(String key) async {
    try {
      final Database db = await database;

      final List<Map<String, dynamic>> maps = await db.query(
        tableName,
        where: "createTime = ?",
        whereArgs: [key],
      );
      return List.generate(maps.length, (i) {
        return TodoModel(
          title: maps[i]['title'] as String,
          date: maps[i]['date'] as String,
          detail: maps[i]['detail'] as String,
          createTime: maps[i]['createTime'] as String,
          completeFlag: maps[i]['completeFlag'] == "0"
              ? CompleteFlag.unfinished
              : CompleteFlag.completion,
        );
      }).first;
    } catch (error, stackTrace) {
      log("stackTrace: $stackTrace");

      log("Todoの取得エラー: $error");
      return throw ("Todoの取得に失敗しました");
    }
  }

  /// Todoの全件削除
  @override
  Future<void> allDelete() async {
    try {
      final Database db = await database;
      db.delete(tableName);
    } catch (error, stackTrace) {
      log("stackTrace: $stackTrace");

      log("Todoの全件削除エラー: $error");
      return throw ("Todoの削除に失敗しました");
    }
  }

  /// Todoを一件削除
  @override
  Future<void> delete(String key) async {
    final Database db = await database;
    try {
      db.delete(
        tableName,
        where: "createTime = ?",
        whereArgs: [key],
      );
      log('Todo削除: title: $title, date: $date, detail: $detail, completeFlag: $completeFlag, createTime: $createTime');
    } catch (e, s) {
      log("Todoの削除エラー: $e");

      log("stackTrace: $s");
      return throw ("Todoの削除に失敗しました");
    }
  }
}
