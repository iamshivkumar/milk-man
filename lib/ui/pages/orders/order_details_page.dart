import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:milk_man_app/core/models/order.dart';
import 'package:milk_man_app/core/enums/order_status.dart';
import 'package:milk_man_app/core/providers/repository_provider.dart';
import 'package:milk_man_app/ui/pages/profile/providers/profile_provider.dart';
import 'package:milk_man_app/ui/utils/dates.dart';
import 'package:milk_man_app/ui/utils/utils.dart';
import 'package:milk_man_app/ui/widgets/tow_text_row.dart';

import 'widgets/white_card.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;
  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final repository = context.read(repositoryProvider);
    final profile = context.read(profileProvider).data!.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      bottomNavigationBar: order.deliveryDate.isAfter(Dates.today) &&
              order.deliveryDate.isBefore(
                Dates.today.add(
                  Duration(
                    hours: 23,
                    minutes: 59,
                  ),
                ),
              )
          ? Material(
              color: theme.cardColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Row(
                  children: [
                    order.status != OrderStatus.cancelled &&
                            order.status != OrderStatus.returned
                        ? Expanded(
                            child: MaterialButton(
                              color: theme.accentColor,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      "Are you sure you want set as ${order.status == OrderStatus.delivered ? "returned" : "cancelled"}?",
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
                                          if (order.status ==
                                              OrderStatus.delivered) {
                                            repository.setOrderAsReturned(
                                              milkManId: profile.id,
                                              order: order,
                                            );
                                          } else {
                                            repository.setOrderAsCancelled(
                                              id: order.id,
                                              customerId: order.customerId,
                                              totalAmount: order.total +
                                                  order.walletAmount,
                                            );
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: Text("YES"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text(order.status == OrderStatus.delivered
                                  ? "RETURN"
                                  : "CANCEL"),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      width: order.status != OrderStatus.cancelled &&
                              order.status != OrderStatus.delivered
                          ? 8
                          : 0,
                    ),
                    order.status != OrderStatus.delivered
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
                                          repository
                                              .setOrderAsDelivered(
                                                milkManId: profile.id,
                                                order: order,
                                              );
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
                    'Products',
                    style: style.headline6,
                  ),
                ),
                Column(
                  children: order.products.map((e) {
                    return ListTile(
                      title: Text(e.name),
                      leading: Image.network(e.image),
                      subtitle: Text(
                          e.qt.toString() + " Items x ₹" + e.price.toString()),
                      trailing: Text(
                        "₹" + (e.qt * e.price).toString(),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
          WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Order Summary',
                    style: style.headline6,
                  ),
                ),
                TwoTextRow(
                  text1: "Items (${order.items})",
                  text2: '₹' + order.price.toString(),
                ),
                TwoTextRow(
                  text1: "Wallet Amount",
                  text2: '₹' + order.walletAmount.toString(),
                ),
                TwoTextRow(
                  text1: "Razorpay",
                  text2: '₹' + order.total.toString(),
                ),
                Divider(),
                TwoTextRow(
                  text1: 'Total Price',
                  text2: '₹' + order.price.toString(),
                )
              ],
            ),
          ),
          WhiteCard(
            child: Column(
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
              ],
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
                  text2: order.status,
                ),
                TwoTextRow(
                  text1: "Delivery Date",
                  text2: Utils.formatedDate(order.deliveryDate),
                ),
                TwoTextRow(
                  text1: "Address",
                  text2: order.address.formated,
                ),
              ],
            ),
          ),
          WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Payment',
                    style: style.headline6,
                  ),
                ),
                TwoTextRow(
                  text1: "Status",
                  text2: order.paid ? "Paid" : "Not paid",
                ),
                TwoTextRow(
                  text1: "Payment Method",
                  text2: order.paymentMethod,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
