import 'package:intl/intl.dart';

class Utils {
  static List<String> categories = [
    'Popular',
    'Fruits',
    "Vegetables",
    'Food',
    'Drinks',
    'Snacks'
  ];

  static DateTime now = DateTime.now();
  static DateTime today = DateTime(now.year, now.month, now.day);

  static List<DateTime> deliveryDates = [
    today,
    today.add(
      Duration(days: 1),
    ),
    today.add(
      Duration(days: 2),
    ),
  ];

  static String weekday(DateTime dateTime) {
    if (dateTime == today) {
      return "Today";
    } else if (dateTime ==
        today.add(
          Duration(days: 1),
        )) {
      return "Tommorow";
    } else {
      return DateFormat(DateFormat.WEEKDAY).format(dateTime);
    }
  }

  static String weekD(DateTime dateTime) {
    return DateFormat(DateFormat.WEEKDAY).format(dateTime).split('').first;
  }

  static String formatedDate(DateTime dateTime) =>
      DateFormat(DateFormat.MONTH_DAY).format(dateTime);
}
