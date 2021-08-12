import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/core/models/delivery.dart';
import 'package:milk_man_app/core/models/order.dart';
import 'package:milk_man_app/core/models/order_params.dart';
import 'package:milk_man_app/core/models/order_status.dart';
import 'package:milk_man_app/core/models/subscription.dart';
import 'package:milk_man_app/ui/utils/dates.dart';

final repositoryProvider = Provider<Repository>((ref) => Repository());

class Repository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User get user => _auth.currentUser!;

  Stream<List<Order>> ordersStream(OrderParams params) {
    final date = params.dateTime.subtract(Duration(days: 1));
    return _firestore
        .collection('orders')
        .where('milkManId', isEqualTo: user.phoneNumber!.split("+91").last)
        .where(
          'createdOn',
          isGreaterThanOrEqualTo: date,
          isLessThanOrEqualTo: date.add(
            Duration(hours: 23, minutes: 59),
          ),
        )
        .where('status', isEqualTo: params.status)
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

  Stream<List<Subscription>> get subscriptionsStream => _firestore
      .collection('subscription')
      .where('milkManId', isEqualTo: user.phoneNumber!.split("+91").last)
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

  Future<List<String>> getAreas(String mobile) async {
    final data = await _firestore
        .collection('milkMans')
        .where('mobile', isEqualTo: mobile)
        .get();
    if (data.docs.isEmpty) {
      return Future.error("Milk man not exists.");
    } else {
      return data.docs.first.data()['areas'].cast<String>();
    }
  }

  void saveDeliveries(
      {required String id, required List<Delivery> deliveries}) {
    _firestore.collection('subscription').doc(id).update({
      'deliveries': deliveries.map((e) => e.toMap()).toList(),
    });
  }

  void addWalletAmount({required double amount}) {
    _firestore.collection('users').doc(user.uid).update({
      'walletAmount': FieldValue.increment(amount),
    });
  }

  void setOrderAsDelivered(String id) {
    _firestore.collection('orders').doc(id).update({
      "status": OrderStatus.delivered,
    });
  }

  void setOrderAsCancelled({required String id,required String customerId,required double totalAmount}) {
    final batch = _firestore.batch();
    batch.update(_firestore.collection('orders').doc(id), {
      "status": OrderStatus.cancelled,
    });
    batch.update(_firestore.collection('users').doc(customerId), {
      "walletAmount": FieldValue.increment(totalAmount),
    });
    batch.commit();
  }
}
