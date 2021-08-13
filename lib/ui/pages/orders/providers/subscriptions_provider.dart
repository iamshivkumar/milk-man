import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/core/providers/repository_provider.dart';

final subscriptionsProvider = StreamProvider(
  (ref) => ref.read(repositoryProvider).subscriptionsStream,
);
