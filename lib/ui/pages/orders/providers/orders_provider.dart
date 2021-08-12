import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/core/models/order.dart';
import 'package:milk_man_app/core/models/order_params.dart';
import 'package:milk_man_app/core/providers/repository_provider.dart';

final ordersProvider = StreamProvider.family<List<Order>, OrderParams>(
  (ref, date) => ref.read(repositoryProvider).ordersStream(date),
);
