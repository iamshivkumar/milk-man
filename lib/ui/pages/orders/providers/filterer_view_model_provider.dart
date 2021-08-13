import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/ui/pages/profile/providers/profile_provider.dart';

final filtererViewModelProvider =
    ChangeNotifierProvider((ref) => FiltererViewModel(ref));

class FiltererViewModel extends ChangeNotifier {
  final ProviderReference ref;
  FiltererViewModel(this.ref);

  String? _area;

  String? get area => _area??ref.read(profileProvider).data!.value.areas.first;
  set area(String? area) {
    _area = area;
    notifyListeners();
  }

  String _number = '';
  String get number => _number;
  set number(String number) {
    _number = number;
    notifyListeners();
  }
}
