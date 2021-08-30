import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/models/customer.dart';
import '../../../../core/providers/repository_provider.dart';

final customersProvider = StreamProvider<List<Customer>>((ref) {
  return ref.read(repositoryProvider).customersStream;
});
