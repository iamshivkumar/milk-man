import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/providers/repository_provider.dart';

final subscriptionsProvider = StreamProvider(
  (ref) => ref.read(repositoryProvider).subscriptionsStream,
);
