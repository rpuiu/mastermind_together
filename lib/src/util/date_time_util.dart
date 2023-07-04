import 'package:intl/intl.dart';

String getDayName(int index) {
  return DateFormat.E().format(DateTime(2022, 1, index + 1));
}

List<String> getWeekDaysNames() {
  return List.generate(7, (index) => getDayName(index));
}
