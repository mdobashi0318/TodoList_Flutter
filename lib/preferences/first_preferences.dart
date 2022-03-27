import 'package:shared_preferences/shared_preferences.dart';

class FirstPreferences {
  /// Todoを作成したことあるかどうかを取得するキー値
  String get _firstCreateTodo => 'FirstCreateTodo';

  /// Todoを作成したことを保存する
  Future<void> saveFirstCreateTodo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstCreateTodo, true);
  }

  /// Todoを作成したことあるかどうかを取得する
  Future<bool> getFirstCreateTodo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstCreateTodo) ?? false;
  }
}
