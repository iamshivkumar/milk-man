import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/models/charge.dart';
import '../../../../core/providers/repository_provider.dart';
import '../../profile/providers/profile_provider.dart';

final amountProvider = StreamProvider.family<List<Charge>, String>(
  (ref, type) {
    return ref.read(repositoryProvider).chargesStream(
        milkManId: ref.watch(profileProvider).data!.value.id, viewType: type);
  },
);
