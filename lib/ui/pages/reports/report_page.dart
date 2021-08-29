import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/ui/pages/orders/providers/calendar_view_model_provider.dart';
import 'package:milk_man_app/ui/pages/orders/providers/orders_provider.dart';
import 'package:milk_man_app/ui/pages/orders/providers/subscriptions_provider.dart';
import 'package:milk_man_app/ui/pages/orders/widgets/My_calendar.dart';
import 'package:milk_man_app/ui/pages/reports/widgets/product_report_card.dart';
import 'package:milk_man_app/ui/utils/generator.dart';
import 'package:milk_man_app/ui/widgets/loading.dart';

class ReportPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final calendarModel = watch(calendarViewModelProvider);
    final ordersStream = watch(ordersProvider(calendarModel.selectedDate));
    final subscriptionsStream = watch(subscriptionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Report"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(0),
            child: Column(
              children: [
                MyCalendar(
                  model: calendarModel,
                ),
              ],
            ),
          ),
          Expanded(
            child: ordersStream.when(
              data: (orders) => subscriptionsStream.when(
                data: (subscriptions) => ListView(
                  children: Generator.reportProducts(
                    subscriptions: subscriptions
                        .where((element) => element.deliveries
                            .where((d) => d.date == calendarModel.selectedDate)
                            .isNotEmpty)
                        .toList(),
                    orders: orders,
                    dateTime: calendarModel.selectedDate,
                  )
                      .map(
                        (e) => ProductReportCard(product: e),
                      )
                      .toList(),
                ),
                loading: () => Loading(),
                error: (e, s) => Text(
                  e.toString(),
                ),
              ),
              loading: () => Loading(),
              error: (e, s) => Text(
                e.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
