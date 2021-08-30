import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/subscription.dart';
import '../subscription_order_details_page.dart';

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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubscriptionOrderDetailsPage(
              delivery: delivery,
              order: subscription,
            ),
          ),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(subscription.customerName),
              subtitle: Text(subscription.address.formated),
              trailing: Text(
                "SUBSCRIPTION",
                style: style.overline,
              ),
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
