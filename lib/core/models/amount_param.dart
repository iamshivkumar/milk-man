import '../../ui/utils/dates.dart';

class AmountParam {
  final DateTime start;
  final DateTime end;

  AmountParam({required this.start, required this.end});

  factory AmountParam.fromViewType(String type) {
    switch (type) {
      case "Last 7 days":
        return AmountParam(
          start: Dates.today.subtract(
            Duration(days: 6),
          ),
          end: Dates.today.add(
            Duration(hours: 23, minutes: 59),
          ),
        );
      case "Last 30 days":
        return AmountParam(
          start: Dates.today.subtract(
            Duration(days: 29),
          ),
          end: Dates.today.add(
            Duration(hours: 23, minutes: 59),
          ),
        );
      default:
        return AmountParam(
          start: Dates.today,
          end: Dates.today.add(
            Duration(hours: 23, minutes: 59),
          ),
        );
    }
  }
}
