import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/core/models/order_params.dart';
import 'package:milk_man_app/core/models/order_status.dart';
import 'package:milk_man_app/ui/pages/orders/providers/calendar_view_model_provider.dart';
import 'package:milk_man_app/ui/pages/orders/widgets/My_calendar.dart';
import 'package:milk_man_app/ui/pages/orders/widgets/order_card.dart';
import 'package:milk_man_app/ui/widgets/loading.dart';

import 'providers/orders_provider.dart';

class OrdersPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final calendarModel = watch(calendarViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: DefaultTabController(
        length: OrderStatus.values.length,
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(0),
              child: Column(
                children: [
                  MyCalendar(
                    model: calendarModel,
                  ),
                  TabBar(
                    tabs: OrderStatus.values
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
                children: OrderStatus.values
                    .map(
                      (e) => Builder(
                        builder: (context) {
                          final ordersSteam = watch(
                            ordersProvider(
                              OrderParams(
                                status: e,
                                dateTime: calendarModel.selectedDate,
                              ),
                            ),
                          );
                          return ordersSteam.when(
                            data: (orders) => ListView(
                              children: orders
                                  .map(
                                    (o) => OrderCard(order: o),
                                  )
                                  .toList(),
                            ),
                            loading: () => Loading(),
                            error: (e, s) => Text(
                              e.toString(),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
