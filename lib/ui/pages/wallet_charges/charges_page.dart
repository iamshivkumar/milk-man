import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/labels.dart';
import '../../utils/utils.dart';
import '../../widgets/loading.dart';
import '../profile/providers/profile_provider.dart';
import 'providers/charges_view_model_provider.dart';

class WalletChargesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(chargesViewModelProvider);
    final profile = watch(profileProvider).data!.value;
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallet Charges History"),
      ),
      body: model.charges.isEmpty
          ? Loading()
          : NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (!model.busy &&
                    notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                  model.getProductsMore();
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async =>
                    context.refresh(chargesViewModelProvider),
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        model.charges
                            .map(
                              (e) => Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      (e.from == profile.id ? "- " : "+") +
                                          "${Labels.rupee}${e.amount}",
                                      style: TextStyle(
                                          color: e.from == profile.id
                                              ? Colors.red
                                              : Colors.green),
                                    ),
                                    subtitle: Text(e.type),
                                    trailing:
                                        Text(Utils.formatedDateTime(e.createdAt)),
                                  ),
                                  Divider(),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: model.loading && model.charges.length > 8
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                            : SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
