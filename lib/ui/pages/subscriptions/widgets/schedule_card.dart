import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:milk_man_app/core/models/subscription.dart';
import 'package:milk_man_app/ui/utils/labels.dart';

class ScheduleCard extends StatelessWidget {
  final Subscription subscription;
  final DateTime dateTime;

  const ScheduleCard(
      {Key? key, required this.subscription, required this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final delivery = subscription.deliveries
        .where((element) => element.date == dateTime)
        .first;

    return Card(
      child: InkWell(
        // onTap: () => Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => OrderDetailsPage(
        //       key: Key(order.id),
        //       order: order,
        //     ),
        //   ),
        // ),
        child: Column(
          children: [
            ListTile(
              title: Text(subscription.customerName),
              subtitle: Text(subscription.address.formated),
            ),
            ListTile(
              leading: Image.network(subscription.image),
              title: Text(subscription.productName),
              subtitle: Text(
                  "${subscription.option.salePriceLabel} / ${subscription.option.amountLabel}"),
              trailing: Text(
                delivery.quantity.toString(),
                style: style.headline6,
              ),
            )
          ],
        ),
      ),
    );
  }
}
