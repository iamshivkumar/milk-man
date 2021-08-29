import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/core/models/charge.dart';
import 'package:milk_man_app/core/models/customer.dart';
import 'package:milk_man_app/core/models/delivery.dart';
import 'package:milk_man_app/core/models/option.dart';
import 'package:milk_man_app/core/models/order_product.dart';
import 'package:milk_man_app/core/models/profile.dart';
import 'package:milk_man_app/core/models/order.dart';
import 'package:milk_man_app/core/models/order_params.dart';
import 'package:milk_man_app/core/enums/order_status.dart';
import 'package:milk_man_app/core/models/subscription.dart';
import 'package:milk_man_app/ui/utils/dates.dart';

final repositoryProvider = Provider<Repository>((ref) => Repository());

class Repository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User get user => _auth.currentUser!;

  String get mobile =>
      user.phoneNumber!.substring(user.phoneNumber!.length - 10);

  Stream<List<Order>> ordersStream(DateTime d) {
    final date = d.subtract(Duration(days: 1));
    return _firestore
        .collection('orders')
        .where('milkManId', isEqualTo: mobile)
        .where(
          'createdOn',
          isGreaterThanOrEqualTo: date,
          isLessThanOrEqualTo: date.add(
            Duration(hours: 23, minutes: 59),
          ),
        )
        .snapshots()
        .map(
      (event) {
        print(event.docs);
        return event.docs
            .map(
              (e) => Order.fromFirestore(e),
            )
            .toList();
      },
    );
  }

  Future<List<Order>> ordersFuture(DateTime dateTime) async {
    final date = dateTime.subtract(Duration(days: 1));
    return await _firestore
        .collection('orders')
        .where('milkManId', isEqualTo: mobile)
        .where(
          'createdOn',
          isGreaterThanOrEqualTo: date,
          isLessThanOrEqualTo: date.add(
            Duration(hours: 23, minutes: 59),
          ),
        )
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Order.fromFirestore(e),
              )
              .toList(),
        );
  }

  Stream<List<Subscription>> get subscriptionsStream => _firestore
      .collection('subscription')
      .where('milkManId', isEqualTo: mobile)
      .where(
        'startDate',
        isGreaterThanOrEqualTo: Dates.today.subtract(
          Duration(days: 30),
        ),
      )
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => Subscription.fromFirestore(e),
            )
            .toList(),
      );

  Future<List<Subscription>> subscriptionsFuture() async {
    return await _firestore
        .collection('subscription')
        .where('milkManId', isEqualTo: mobile)
        .where(
          'startDate',
          isGreaterThanOrEqualTo: Dates.today.subtract(
            Duration(days: 30),
          ),
        )
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Subscription.fromFirestore(e),
              )
              .toList(),
        );
  }

  Stream<List<Customer>> get customersStream => _firestore
      .collection('users')
      .where('milkManId', isEqualTo: mobile)
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => Customer.fromFirestore(e),
            )
            .toList(),
      );

  Stream<Profile> get profileStream {
    return _firestore
        .collection('milkMans')
        .where('mobile', isEqualTo: mobile)
        .snapshots()
        .map(
          (event) => Profile.fromFirestore(event.docs.first),
        );
  }

  void addWalletAmount(
      {required double amount, required String id, required String milkManId}) {
    final batch = _firestore.batch();
    batch.update(_firestore.collection('users').doc(id), {
      'walletAmount': FieldValue.increment(amount),
    });
    batch.update(_firestore.collection('milkMans').doc(milkManId), {
      'walletAmount': FieldValue.increment(-amount),
    });
    batch.set(
      _firestore.collection('charges').doc(),
      Charge(
        amount: amount,
        from: milkManId,
        to: id,
        ids: [id, milkManId],
        type: ChargesType.whileAddWalletAmount,
        createdAt: DateTime.now(),
      ).toMap(),
    );
    batch.commit();
  }

  void setOrderAsDelivered({required Order order, required String milkManId}) {
    final list = order.products
        .where((element) => element.isMilky)
        .map((e) => e.price * e.qt);
    final double amount = list.isNotEmpty ? list.reduce((a, b) => a + b) : 0;
    final batch = _firestore.batch();
    batch.update(_firestore.collection('orders').doc(order.id), {
      "status": OrderStatus.delivered,
    });
    batch.update(_firestore.collection('milkMans').doc(milkManId), {
      'walletAmount': FieldValue.increment(amount),
    });
    batch.set(
      _firestore.collection('charges').doc(),
      Charge(
        amount: amount,
        from: null,
        to: milkManId,
        ids: [milkManId],
        type: ChargesType.whileDeliverOrder,
        createdAt: DateTime.now(),
      ).toMap(),
    );
    batch.commit();
  }

  void setOrderAsCancelled(
      {required String id,
      required String customerId,
      required double totalAmount,
      required List<OrderProduct> products}) {
    final batch = _firestore.batch();
    batch.update(_firestore.collection('orders').doc(id), {
      "status": OrderStatus.cancelled,
    });
    batch.update(_firestore.collection('users').doc(customerId), {
      "walletAmount": FieldValue.increment(totalAmount),
    });
    batch.set(
      _firestore.collection('charges').doc(),
      Charge(
        amount: totalAmount,
        from: null,
        to: customerId,
        ids: [customerId],
        type: ChargesType.whileCancelOrder,
        createdAt: DateTime.now(),
      ).toMap(),
    );

    for (var item in products.where((element) => !element.isMilky)) {
      _firestore.collection('products').doc(item.id).get().then((value) {
        final Iterable list = value.data()!['options'];
        final List<Option> options =
            list.map((e) => Option.fromMap(e)).toList();
        options
            .where((element) => element.amountLabel == item.amountLabel)
            .first
            .increment(item.qt);
        _firestore.collection('products').doc(item.id).update({
          'options': options.map((e) => e.toMap()).toList(),
        });
      });
    }
    batch.commit();
  }

  void setOrderAsReturned({required Order order, required String milkManId}) {
    final list = order.products
        .where((element) => element.isMilky)
        .map((e) => e.price * e.qt);
    final double amount = list.isNotEmpty ? list.reduce((a, b) => a + b) : 0;
    final batch = _firestore.batch();
    batch.update(_firestore.collection('orders').doc(order.id), {
      "status": OrderStatus.returned,
    });
    batch.update(_firestore.collection('users').doc(order.customerId), {
      "walletAmount": FieldValue.increment(order.price),
    });
    batch.set(
      _firestore.collection('charges').doc(),
      Charge(
        amount: order.price,
        from: null,
        to: order.customerId,
        ids: [order.customerId],
        type: ChargesType.whileReturnOrder,
        createdAt: DateTime.now(),
      ).toMap(),
    );
    batch.update(_firestore.collection('milkMans').doc(milkManId), {
      'walletAmount': FieldValue.increment(-amount),
    });
    batch.set(
      _firestore.collection('charges').doc(),
      Charge(
        amount: amount,
        from: milkManId,
        to: null,
        ids: [milkManId],
        type: ChargesType.whileReturnOrder,
        createdAt: DateTime.now(),
      ).toMap(),
    );
    batch.commit();
  }

  Stream<Customer> customerStream(String id) {
    return _firestore.collection("users").doc(id).snapshots().map(
          (event) => Customer.fromFirestore(event),
        );
  }

  void saveDeliveries(
      {required String id, required List<Delivery> deliveries}) {
    _firestore.collection('subscription').doc(id).update({
      'deliveries': deliveries.map((e) => e.toMap()).toList(),
    });
  }

  void deliverSubscriptionOrder(
      {required Subscription subscription, required String id}) {
    try {
      final List<Delivery> deliveries = subscription.deliveries;
      deliveries.where((element) => element.date == Dates.today).first.status =
          OrderStatus.delivered;
      final _batch = _firestore.batch();
      _batch
          .update(_firestore.collection('subscription').doc(subscription.id), {
        'deliveries': deliveries.map((e) => e.toMap()).toList(),
      });
      final amount = deliveries
              .where((element) => element.date == Dates.today)
              .first
              .quantity *
          subscription.option.salePrice;
      _batch.update(
        _firestore.collection('users').doc(subscription.customerId),
        {
          "walletAmount": FieldValue.increment(-amount),
        },
      );
      _batch.update(
        _firestore.collection('milkMans').doc(id),
        {
          "walletAmount": FieldValue.increment(amount),
        },
      );
      _batch.set(
        _firestore.collection('charges').doc(),
        Charge(
          amount: amount,
          from: subscription.customerId,
          to: id,
          ids: [id, subscription.customerId],
          type: ChargesType.whileDeliverSubscriptionOrder,
          createdAt: DateTime.now(),
        ).toMap(),
      );
      _batch.commit();
    } catch (e) {
      print(e);
    }
  }

  void returnSubscriptionOrder(
      {required Subscription subscription, required String id}) {
    final List<Delivery> deliveries = subscription.deliveries;
    deliveries.where((element) => element.date == Dates.today).first.status =
        OrderStatus.returned;
    final _batch = _firestore.batch();
    _batch.update(_firestore.collection('subscription').doc(subscription.id), {
      'deliveries': deliveries.map((e) => e.toMap()).toList(),
    });
    final amount = deliveries
            .where((element) => element.date == Dates.today)
            .first
            .quantity *
        subscription.option.salePrice;
    _batch.update(
      _firestore.collection('users').doc(subscription.customerId),
      {
        "walletAmount": FieldValue.increment(amount),
      },
    );
    _batch.update(
      _firestore.collection('milkMans').doc(id),
      {
        "walletAmount": FieldValue.increment(-amount),
      },
    );
    _batch.set(
      _firestore.collection('charges').doc(),
      Charge(
        amount: amount,
        from: id,
        to: subscription.customerId,
        ids: [id, subscription.customerId],
        type: ChargesType.whileReturnSubscriptionOrder,
        createdAt: DateTime.now(),
      ).toMap(),
    );
    _batch.commit();
  }

  Future<void> request({required String id, required String area}) async {
    await _firestore.collection('milkMans').doc(id).update({
      "pendingAreas": FieldValue.arrayUnion([area]),
    });
  }

  Future<List<QueryDocumentSnapshot>> getCharges(
      {int limit = 10,
      DocumentSnapshot? last,
      required String milkManId}) async {
    Query ref = _firestore
        .collection('charges')
        .where("ids", arrayContains: milkManId)
        .limit(limit);
    if (last != null) {
      ref = ref.startAfterDocument(last);
    }
    return await ref.get().then((value) => value.docs);
  }
}
