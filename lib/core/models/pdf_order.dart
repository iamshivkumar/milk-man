import 'order.dart';
import 'subscription.dart';

class PdfOrder {
  final String customerName;
  final String area;
  final String address;
  final String total;
  final List<PdfProduct> products;
  final String status;

  PdfOrder({
    required this.customerName,
    required this.area,
    required this.address,
    required this.total,
    required this.products,
    required this.status,
  });

  factory PdfOrder.fromOrder(Order order) => PdfOrder(
        address: "${order.address.number} ${order.address.landMark}",
        area: order.address.area,
        customerName: order.customerName,
        products: order.products
            .map(
              (e) => PdfProduct(
                name: "${e.name} (${e.amountLabel})",
                price: e.price.toInt().toString(),
                quantity: e.qt.toString(),
              ),
            )
            .toList(),
        total: "${order.price.toInt()}",
        status: order.status,
      );

  factory PdfOrder.fromSubscription(
      {required Subscription subscription, required DateTime date}) {
    final delivery =
        subscription.deliveries.where((element) => element.date == date).first;

    return PdfOrder(
      address:
          "${subscription.address.number} ${subscription.address.landMark}",
      area: subscription.address.area,
      customerName: subscription.customerName,
      products: [
        PdfProduct(
          name:
              "${subscription.productName} (${subscription.option.amountLabel})",
          price: subscription.option.salePrice.toInt().toString(),
          quantity: delivery.quantity.toString(),
        ),
      ],
      total:
          "${(subscription.option.salePrice * delivery.quantity).toInt()}",
      status: delivery.status,
    );
  }
}

class PdfProduct {
  final String name;
  final String price;
  final String quantity;

  PdfProduct({
    required this.name,
    required this.price,
    required this.quantity,
  });
}
