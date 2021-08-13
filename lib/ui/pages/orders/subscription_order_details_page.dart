import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/core/models/delivery.dart';

import 'package:milk_man_app/core/models/order_status.dart';
import 'package:milk_man_app/core/models/subscription.dart';
import 'package:milk_man_app/core/providers/repository_provider.dart';
import 'package:milk_man_app/ui/pages/customers/providers/customer_provider.dart';
import 'package:milk_man_app/ui/pages/customers/widgets/add_wallet_amount_sheet.dart';
import 'package:milk_man_app/ui/utils/dates.dart';
import 'package:milk_man_app/ui/utils/labels.dart';
import 'package:milk_man_app/ui/utils/utils.dart';
import 'package:milk_man_app/ui/widgets/loading.dart';
import 'package:milk_man_app/ui/widgets/tow_text_row.dart';

import 'widgets/white_card.dart';

class SubscriptionOrderDetailsPage extends ConsumerWidget {
  final Subscription order;
  final Delivery delivery;
  const SubscriptionOrderDetailsPage(
      {Key? key, required this.order, required this.delivery})
      : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final customerStream = watch(customerProvider(order.customerId));
    final repository = context.read(repositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription Order Details'),
      ),
      bottomNavigationBar: delivery.date == Dates.today
          ? Material(
              color: theme.cardColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Row(
                  children: [
                    delivery.status != OrderStatus.cancelled &&
                            delivery.status != OrderStatus.returned
                        ? Expanded(
                            child: MaterialButton(
                              color: theme.accentColor,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      "Are you sure you want set as ${delivery.status == OrderStatus.delivered ? "returned" : "cancelled"}?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("NO"),
                                      ),
                                      MaterialButton(
                                        color: theme.accentColor,
                                        onPressed: () {
                                          Navigator.pop(context);
                                          if (delivery.status ==
                                              OrderStatus.delivered) {
                                          } else {
                                            order.deliveries
                                                .where((element) =>
                                                    element.date ==
                                                    delivery.date)
                                                .first
                                                .status = OrderStatus.cancelled;
                                            repository.saveDeliveries(
                                                id: order.id,
                                                deliveries: order.deliveries);
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: Text("YES"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text(
                                  delivery.status == OrderStatus.delivered
                                      ? "RETURN"
                                      : "CANCEL"),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      width: delivery.status != OrderStatus.cancelled &&
                              delivery.status != OrderStatus.delivered
                          ? 8
                          : 0,
                    ),
                    delivery.status != OrderStatus.delivered &&
                            (delivery.quantity * order.option.salePrice) <
                                (customerStream.data?.value.walletAmount ?? 0)
                        ? Expanded(
                            child: MaterialButton(
                              child: Text("DELIVER"),
                              color: theme.accentColor,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      "Are you sure you want set as delivered?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("NO"),
                                      ),
                                      MaterialButton(
                                        color: theme.accentColor,
                                        onPressed: () {
                                          Navigator.pop(context);
                                          repository.deliverSubscriptionOrder(
                                              subscription: order);
                                          Navigator.pop(context);
                                        },
                                        child: Text("YES"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            )
          : SizedBox(),
      body: ListView(
        padding: EdgeInsets.all(4),
        children: [
          WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Product',
                    style: style.headline6,
                  ),
                ),
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      text: order.productName + " ",
                      style: style.subtitle1,
                      children: [
                        TextSpan(
                          text: "(${order.option.amountLabel})",
                          style: style.subtitle1!.copyWith(
                            color: style.caption!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  leading: Image.network(order.image),
                  subtitle: Text(delivery.quantity.toString() +
                      " Items x " +
                      order.option.salePriceLabel),
                  trailing: Text(
                    "₹" +
                        (delivery.quantity * order.option.salePrice).toString(),
                  ),
                )
              ],
            ),
          ),
          WhiteCard(
            child: customerStream.when(
              data: (customer) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Customer Details',
                      style: style.headline6,
                    ),
                  ),
                  TwoTextRow(
                    text1: "Name",
                    text2: order.customerName,
                  ),
                  TwoTextRow(
                    text1: "Phone Number",
                    text2: order.customerMobile,
                  ),
                  TwoTextRow(
                    text1: "Wallet Amount",
                    text2:
                        "${Labels.rupee}${customer.walletAmount.toInt().toString()}",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: MaterialButton(
                      color: theme.accentColor,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 8),
                          Text("Wallet Amount"),
                        ],
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) =>
                              AddWalletAmountSheet(customer.id),
                        );
                      },
                    ),
                  ),
                ],
              ),
              loading: () => Loading(),
              error: (e, s) => Text(
                e.toString(),
              ),
            ),
          ),
          WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Delivery Details',
                    style: style.headline6,
                  ),
                ),
                TwoTextRow(
                  text1: "Status",
                  text2: delivery.status,
                ),
                TwoTextRow(
                  text1: "Delivery Date",
                  text2: Utils.formatedDate(delivery.date),
                ),
                TwoTextRow(
                  text1: "Address",
                  text2: order.address.formated,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
