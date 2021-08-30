import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../orders/providers/calendar_view_model_provider.dart';
import '../orders/providers/orders_provider.dart';
import '../orders/providers/subscriptions_provider.dart';
import '../orders/widgets/My_calendar.dart';
import 'widgets/product_report_card.dart';
import '../../utils/generator.dart';
import '../../widgets/loading.dart';

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
