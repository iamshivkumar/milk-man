import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/labels.dart';
import '../../widgets/loading.dart';
import '../orders/providers/filterer_view_model_provider.dart';
import '../orders/widgets/filterer.dart';
import 'customer_details_page.dart';
import 'providers/customers_provider.dart';

class CustomerTabs {
  static String get lessThan50 => "Less than ${Labels.rupee}50";
  static String get moreThan50 => "More than ${Labels.rupee}50";

  static List<String> get values => [lessThan50, moreThan50];
}

class CustomersPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    
    final filterer = watch(filtererViewModelProvider);
    final customersStream = watch(customersProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Customers"),
      ),
      body: DefaultTabController(
        length: CustomerTabs.values.length,
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(0),
              child: Column(
                children: [
                  Filterer(),
                  TabBar(
                    tabs: CustomerTabs.values
                        .map(
                          (e) => Tab(
                            text: e,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: CustomerTabs.values
                    .map(
                      (e) => customersStream.when(
                        data: (customers) => ListView(
                          children: customers
                              .where((element) => e == CustomerTabs.lessThan50
                                  ? element.walletAmount < 50
                                  : element.walletAmount >= 50)
                              .where(
                                (element) =>
                                    element.area == filterer.area &&
                                    element.number!.startsWith(filterer.number),
                              )
                              .map(
                                (e) => ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CustomerDetailsPage(e.id),
                                      ),
                                    );
                                  },
                                  title: Text(e.name),
                                  subtitle: Text(
                                    "${e.number}, ${e.landMark}, ${e.area}",
                                  ),
                                  trailing: Text(
                                      "${Labels.rupee}${e.walletAmount.toInt()}"),
                                ),
                              )
                              .toList(),
                        ),
                        loading: () => Loading(),
                        error: (e, s) => Text(
                          e.toString(),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
