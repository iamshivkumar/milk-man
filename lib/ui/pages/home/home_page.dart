import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/ui/pages/customers/customers_page.dart';
import 'package:milk_man_app/ui/pages/orders/orders_page.dart';
import 'package:milk_man_app/ui/pages/pdfs/pdfs_page.dart';
import 'package:milk_man_app/ui/pages/profile/providers/profile_provider.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final profile = watch(profileProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Milk Man"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Orders"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrdersPage(),
                ),
              );
            },
          ),
          
          ListTile(
            title: Text("Customers"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomersPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text("Orders Pdfs"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfsPage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
