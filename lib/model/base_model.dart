import 'package:sqflite/sqflite.dart';

abstract class BaseModel<T> {
  String tableName;
  Future<Database> database;

  Future<T> find(String key);
  Future<List<T>> allFind();
  Future<void> add();
  Future<void> update(String key);
  Future<void> delete(String key);
  Future<void> allDelete();
}
