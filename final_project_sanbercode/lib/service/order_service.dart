import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_sanbercode/model/order.dart';

class OrderService {
  final CollectionReference _orderCollection =
      FirebaseFirestore.instance.collection('order');

  Future<void> addOrder(OrderModel order) async {
    final docRef = _orderCollection.doc();
    order.id = docRef.id;
    await docRef.set(order.toJson());
  }

  Stream<List<OrderModel>> getOrderList() {
    return _orderCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

    Future<void> deleteOrder(String orderId) async {
    await _orderCollection.doc(orderId).delete();
  }
}
