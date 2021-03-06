import 'package:cloud_firestore/cloud_firestore.dart';

import 'delivery_address.dart';
import 'order_product.dart';

class Order {
  final String id;
    final String orderId;
  final String customerId;
  final String customerName;
  final String customerMobile;

  final double price;
  final double walletAmount;
  final double total;
  final String status;
    final bool packed;

  final List<OrderProduct> products;
  final int items;
  final String? milkManId;
  final String paymentMethod;
  final bool paid;
  final String? paymentId;
  final DateTime createdOn;
  final DeliveryAddress address;
  final String? refundReason;

  DateTime get deliveryDate => createdOn.add(Duration(days: 1));

  Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerMobile,
    required this.price,
    required this.walletAmount,
    required this.total,
    required this.status,
    required this.products,
    required this.items,
    this.milkManId,
    required this.paymentMethod,
    required this.paid,
    this.paymentId,
    required this.createdOn,
    required this.address,
    this.refundReason,
    required this.packed,
    required this.orderId,
  });



  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      customerId: map['customerId'],
      customerName: map['customerName'],
      customerMobile: map['customerMobile'],
      price: map['price'].toDouble(),
      walletAmount: map['walletAmount'].toDouble(),
      status: map['status'],
      products: List<OrderProduct>.from(
        map['products'].map(
          (x) => OrderProduct.fromMap(x),
        ),
      ),
      items: map['items'],
      milkManId: map['milkManId'],
      paymentMethod: map['paymentMethod'],
      paid: map['paid'],
      paymentId: map['paymentId'],
      createdOn: map['createdOn'].toDate(),
      total: map['total'].toDouble(),
      address: DeliveryAddress.fromMap(map['address']),
      refundReason: map['refundReason'],
      packed: map['packed'],
      orderId: map['orderId']
    );
  }
}
