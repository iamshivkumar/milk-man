import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/core/models/profile.dart';
import 'package:milk_man_app/core/providers/repository_provider.dart';

final profileProvider = StreamProvider<Profile>(
  (ref) {
    return ref.read(repositoryProvider).profileStream;
  },
);
