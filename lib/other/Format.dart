import 'package:intl/intl.dart';

class Format {
  /// 現在時間を取得する
  String get createTime => _getNowDateFormat();

  /// 現在時間を取得する
  String _getNowDateFormat() {
    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyy/MM/dd HH:MM:SS.ssss');
    return outputFormat.format(now);
  }

  /// 引数のDateTimeを文字列にして返す
  String setFormatString(DateTime date) {
    DateFormat outputFormat = DateFormat('yyyy/MM/dd');
    return outputFormat.format(date);
  }
}
