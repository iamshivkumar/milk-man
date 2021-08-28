import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/ui/pages/area_requests/area_requests_page.dart';
import 'package:milk_man_app/ui/pages/auth/providers/auth_view_model_provider.dart';
import 'package:milk_man_app/ui/pages/customers/customers_page.dart';
import 'package:milk_man_app/ui/pages/orders/orders_page.dart';
import 'package:milk_man_app/ui/pages/pdfs/pdfs_page.dart';
import 'package:milk_man_app/ui/pages/profile/providers/profile_provider.dart';
import 'package:milk_man_app/ui/pages/reports/report_page.dart';
import 'package:milk_man_app/ui/pages/wallet_charges/charges_page.dart';
import 'package:milk_man_app/ui/utils/labels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/my_card.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final profile = watch(profileProvider).data!.value;
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

