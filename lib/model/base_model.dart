import 'package:sqflite/sqflite.dart';

abstract class BaseModel {
  String tableName;
  Future<Database> database;

  Future<void> find() async {}
  Future<void> allFind() async {}
  Future<void> add() async {}
  Future<void> update() async {}
  Future<void> delete() async {}
  Future<void> allDelete() async {}
}
