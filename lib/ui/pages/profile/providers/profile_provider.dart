import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/models/profile.dart';
import '../../../../core/providers/repository_provider.dart';

final profileProvider = StreamProvider<Profile>(
  (ref) {
    return ref.read(repositoryProvider).profileStream;
  },
);
