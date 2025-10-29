class DateComponents {
  final String year;
  final String month;
  final String day;
  final String hour;
  final String minute;
  final String second;
  final String dateOnly;
  final String timeOnly;
  final String monthDate;
  final String hourMinute;

  DateComponents({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
    required this.dateOnly,
    required this.timeOnly,
    required this.monthDate,
    required this.hourMinute
  });
}

DateComponents dateFormater(String date) {
  if (date.length != 19) {
    throw ArgumentError('Invalid');
  }

  return DateComponents(
    year: date.substring(0, 4),
    month: date.substring(5, 7),
    day: date.substring(8, 10),
    hour: date.substring(11, 13),
    minute: date.substring(14, 16),
    second: date.substring(17, 19),
    dateOnly: date.substring(0, 10),
    timeOnly: date.substring(11, 19),
    monthDate: date.substring(5, 10),
    hourMinute: date.substring(11, 16),
  );
}