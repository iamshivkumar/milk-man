import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/core/models/order_status.dart';
import 'package:milk_man_app/ui/pages/orders/providers/calendar_view_model_provider.dart';
import 'package:milk_man_app/ui/pages/orders/widgets/My_calendar.dart';
import 'package:milk_man_app/ui/pages/subscriptions/providers/subscriptions_provider.dart';
import 'package:milk_man_app/ui/widgets/loading.dart';

import 'widgets/schedule_card.dart';

class DeliverySchedulePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final calendarModel = watch(calendarViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Subscriptions Deliveries"),
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
                          final subscriptionsStream =
                              watch(subscriptionsProvider);
                          return subscriptionsStream.when(
                            data: (subscriptions) => ListView(
                              children: subscriptions
                                  .where(
                                    (element) => element.deliveries
                                        .where((d) =>
                                            d.date ==
                                                calendarModel.selectedDate &&
                                            d.status == e)
                                        .isNotEmpty,
                                  )
                                  .map(
                                    (e) => ScheduleCard(
                                      dateTime: calendarModel.selectedDate,
                                      subscription: e,
                                    ),
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
