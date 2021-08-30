import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref)=>HomeViewModel());

class HomeViewModel extends ChangeNotifier {
  final List<String> viewTypes = ["Today", "Last 7 days","Last 30 days"];


  String _viewType = "Today";
  String get viewType => _viewType;
  set viewType(String viewType) {
    _viewType = viewType;
    notifyListeners();
  }
}