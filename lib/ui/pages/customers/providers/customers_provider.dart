import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/core/models/customer.dart';
import 'package:milk_man_app/core/providers/repository_provider.dart';

final customersProvider = StreamProvider<List<Customer>>((ref) {
  return ref.read(repositoryProvider).customersStream;
});
