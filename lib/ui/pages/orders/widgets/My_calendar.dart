import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../utils/dates.dart';
import '../../../utils/utils.dart';
import '../providers/calendar_view_model_provider.dart';

class MyCalendar extends StatelessWidget {
  const MyCalendar({
    Key? key, required this.model,
  }) : super(key: key);
  final CalendarViewModel model;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calenderStyle = CalendarStyle();
    return TableCalendar(
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: theme.accentColor,
          shape: BoxShape.circle,
        ),
        todayTextStyle: calenderStyle.defaultTextStyle,
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: theme.accentColor, width: 1),
          shape: BoxShape.circle,
        ),
      ),
      selectedDayPredicate: (d) => isSameDay(model.selectedDate, d),
      onDaySelected: (d1, d2) {
        print(d1);
        model.selectedDate = DateTime(d1.year, d1.month, d1.day);
      },
      onPageChanged: (d2) => model.focusDate = d2,
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextFormatter: (d, e) => Utils.weekD(d),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      availableCalendarFormats: {
        CalendarFormat.week: "Week",
      },
      calendarFormat: CalendarFormat.week,
      focusedDay: model.focusDate,
      firstDay: Dates.today.subtract(
        Duration(days: 30),
      ),
      lastDay: DateTime(2025),
    );
  }
}
