import 'package:sqflite/sqflite.dart';

abstract class BaseModel<T> {
  String tableName;
  Future<Database> database;

  Future<T> find();
  Future<List<T>> allFind();
  Future<void> add();
  Future<void> update();
  Future<void> delete();
  Future<void> allDelete();
}
