import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:milk_man_app/core/models/order.dart';
import 'package:milk_man_app/ui/pages/orders/order_details_page.dart';
import 'package:milk_man_app/ui/widgets/tow_text_row.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(
              key: Key(order.id),
              order: order,
            ),
          ),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(order.customerName),
              subtitle: Text(order.address.formated),
              trailing: Text(
                "ORDER",
                style: style.overline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Column(
                children: [
                  TwoTextRow(
                    text1: "Items",
                    text2: "${order.items} Items purchased",
                  ),
                  TwoTextRow(
                    text1: "Price",
                    text2: "₹" + order.total.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
