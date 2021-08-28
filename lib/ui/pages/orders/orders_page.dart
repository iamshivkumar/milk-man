import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/core/models/delivery_address.dart';
import 'package:milk_man_app/core/models/order.dart';
import 'package:milk_man_app/core/models/order_params.dart';
import 'package:milk_man_app/core/enums/order_status.dart';
import 'package:milk_man_app/ui/pages/orders/providers/calendar_view_model_provider.dart';
import 'package:milk_man_app/ui/pages/orders/providers/filterer_view_model_provider.dart';
import 'package:milk_man_app/ui/pages/orders/widgets/My_calendar.dart';
import 'package:milk_man_app/ui/pages/orders/widgets/filterer.dart';
import 'package:milk_man_app/ui/pages/orders/widgets/order_card.dart';
import 'package:milk_man_app/ui/pages/orders/widgets/schedule_card.dart';

import 'providers/orders_provider.dart';
import 'providers/subscriptions_provider.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: DefaultTabController(
        length: OrderStatus.values.length,
        child: Column(
          children: [
            Consumer(
              builder: (context, watch, child) {
                final calendarModel = watch(calendarViewModelProvider);
                return Card(
                  margin: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      MyCalendar(
                        model: calendarModel,
                      ),
                      Filterer(),
                      TabBar(
                        isScrollable: true,
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
                );
              },
            ),
            Expanded(
              child: TabBarView(
                children: OrderStatus.values
                    .map(
                      (e) => Consumer(
                        builder: (context, watch, child) {
                          final filterer = watch(filtererViewModelProvider);
                          final calendarModel =
                              watch(calendarViewModelProvider);

                          final orders = watch(
                                ordersProvider(
                                  calendarModel.selectedDate,
                                ),
                              )
                                  .data
                                  ?.value
                                  .where((element) => element.status == e).toList() ??
                              [];
                          final subscriptions = watch(subscriptionsProvider)
                                  .data
                                  ?.value
                                  .where((element) => element.deliveries
                                      .where((d) =>
                                          d.date ==
                                              calendarModel.selectedDate &&
                                          d.status == e)
                                      .isNotEmpty)
                                  .toList() ??
                              [];
                          return ListView(
                            children: (orders.cast<dynamic>() +
                                    subscriptions.cast<dynamic>())
                                .where((element) {
                                  final address =
                                      element.address as DeliveryAddress;
                                  return address.area == filterer.area &&
                                      address.number
                                          .startsWith(filterer.number);
                                })
                                .map(
                                  (o) => o is Order
                                      ? OrderCard(order: o)
                                      : ScheduleCard(
                                          subscription: o,
                                          dateTime: calendarModel.selectedDate,
                                        ),
                                )
                                .toList(),
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
