import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/core/providers/repository_provider.dart';

final requestAreaViewModelProvider = Provider((ref)=>RequestAreaViewModel(ref));

class RequestAreaViewModel {
  final ProviderReference ref;

  RequestAreaViewModel(this.ref);

  Repository get _repository => ref.read(repositoryProvider);

  late String area;
  late String city;

  void request({required VoidCallback onRequest,required String id})async{
    try {
      await _repository.request(id: id, area: "$area, $city");
      onRequest();
    } catch (e) {
    }
  } 
}