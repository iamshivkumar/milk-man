import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/models/customer.dart';
import '../../utils/labels.dart';
import 'package:url_launcher/url_launcher.dart';

import 'providers/customers_provider.dart';
import 'widgets/add_wallet_amount_sheet.dart';

class CustomerDetailsPage extends ConsumerWidget {
  final String id;

  CustomerDetailsPage(this.id);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final customers = watch(customersProvider)
        .data!
        .value
        .where((element) => element.id == id)
        .toList();
    final Customer? customer = customers.isNotEmpty ? customers.first : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(customer?.name ?? ''),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 4),
        child: MaterialButton(
          color: theme.accentColor,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text("Wallet Amount"),
            ],
          ),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => AddWalletAmountSheet(id),
            );
          },
        ),
      ),
      body: customer != null
          ? ListView(
              padding: EdgeInsets.all(8),
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(customer.name),
                ),
                ListTile(
                  onTap: (){
                    launch('tel:${customer.mobile}');
                  },
                  leading: Icon(Icons.call),
                  title: Text(customer.mobile),
                ),
                ListTile(
                  leading: Icon(Icons.location_pin),
                  title: Text(
                      "${customer.number}, ${customer.landMark}, ${customer.area}"),
                ),
                ListTile(
                  leading: Icon(Icons.account_balance_wallet),
                  title:
                      Text("${Labels.rupee}${customer.walletAmount.toInt()}"),
                ),
              ],
            )
          : SizedBox(),
    );
  }
}
