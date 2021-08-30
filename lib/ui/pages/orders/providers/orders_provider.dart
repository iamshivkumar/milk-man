import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/models/order.dart';
import '../../../../core/models/order_params.dart';
import '../../../../core/providers/repository_provider.dart';

final ordersProvider = StreamProvider.family<List<Order>, DateTime>(
  (ref, date) => ref.read(repositoryProvider).ordersStream(date),
);
