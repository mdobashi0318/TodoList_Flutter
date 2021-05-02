import 'package:intl/intl.dart';

class Format {
  String get createTime => _getNowDateFormat();

  String _getNowDateFormat() {
    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyy/MM/dd HH:MM:SS.ssss');
    return outputFormat.format(now);
  }
}
