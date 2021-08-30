import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/dates.dart';

final calendarViewModelProvider =
    ChangeNotifierProvider.autoDispose<CalendarViewModel>((ref) => CalendarViewModel());

class CalendarViewModel extends ChangeNotifier {
  DateTime _selectedDate = Dates.today;
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  DateTime _focusDate = Dates.today;
  DateTime get focusDate => _focusDate;
  set focusDate(DateTime focusDate) {
    _focusDate = focusDate;
    notifyListeners();
  }

  bool get editable => Dates.now.isBefore(
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 5),
      );
}
