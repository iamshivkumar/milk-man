import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/labels.dart';
import '../area_requests/area_requests_page.dart';
import '../auth/providers/auth_view_model_provider.dart';
import '../customers/customers_page.dart';
import '../orders/orders_page.dart';
import '../pdfs/pdfs_page.dart';
import '../profile/providers/profile_provider.dart';
import '../reports/report_page.dart';
import '../wallet_charges/charges_page.dart';
import 'providers/amount_provider.dart';
import 'providers/home_view_model_provider.dart';
import 'widgets/my_card.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final profile = watch(profileProvider).data!.value;
    final model = watch(homeViewModelProvider);
    final chargesStream = watch(amountProvider(model.viewType));
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      backgroundColor: theme.primaryColorLight,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(4),
          children: [
            ListTile(
              title: Text(profile.name),
              subtitle: Text("+91" + profile.mobile),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_balance_wallet),
                  SizedBox(width: 8),
                  Text(
                    Labels.rupee + profile.walletAmount.toInt().toString(),
                    style: style.headline6,
                  ),
                ],
              ),
            ),
            Card(
              child: chargesStream.when(
                data: (charges) {
                  double value = 0;
                  for (var item in charges) {
                    if (item.from == profile.id) {
                      value = value - item.amount;
                    } else if (item.to == profile.id) {
                      value = value + item.amount;
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            value: model.viewType,
                            onChanged: (v) => model.viewType = v!,
                            items: model.viewTypes
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    child: Text(e),
                                    value: e,
                                  ),
                                )
                                .toList(),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${Labels.rupee}$value"),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => ListTile(),
                error: (e, s) => ListTile(
                  subtitle: Text(
                    e.toString(),
                  ),
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: [
                MyCard(
                  image: "assets/order.png",
                  name: "Orders",
                  widget: OrdersPage(),
                ),
                MyCard(
                  image: "assets/customer.png",
                  name: "Customers",
                  widget: CustomersPage(),
                ),
                MyCard(
                  image: "assets/pdf.png",
                  name: "Orders Pdfs",
                  widget: PdfsPage(),
                ),
                MyCard(
                  image: "assets/area.png",
                  name: "Areas",
                  widget: AreaRequestsPage(),
                ),
                MyCard(
                  image: "assets/charges_history.png",
                  name: "Wallet Charges History",
                  widget: WalletChargesPage(),
                ),
                MyCard(
                  image: "assets/charges_history.png",
                  name: "Daily Report",
                  widget: ReportPage(),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                context.read(authViewModelProvider).signOut();
              },
              child: Text("SIGNOUT"),
            ),
          ],
        ),
      ),
    );
  }
}
