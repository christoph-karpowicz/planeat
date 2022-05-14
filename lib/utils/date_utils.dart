import 'package:intl/intl.dart';

String getSqliteDate(String day, String hours, String minutes) {
  return "$day $hours:$minutes:00.000Z";
}

String getSqliteDateTime(DateTime time) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  return "${formatter.format(time)}.000Z";
}
