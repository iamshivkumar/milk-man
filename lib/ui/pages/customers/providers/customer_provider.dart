import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/models/customer.dart';
import '../../../../core/providers/repository_provider.dart';

final customerProvider = StreamProvider.family<Customer, String>(
  (ref, id) => ref.read(repositoryProvider).customerStream(id),
);
