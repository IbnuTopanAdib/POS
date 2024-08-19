import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_sanbercode/model/payment_list.dart';

class PaymentDummyService {
  final CollectionReference _paymentCollection =
      FirebaseFirestore.instance.collection('list_payment');

  Future<List<PaymentType>> getPayment() async {
    QuerySnapshot snapshot = await _paymentCollection.get();
    return snapshot.docs.map((doc) {
      return PaymentType.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

    Stream<List<PaymentType>> getPaymentStream() {
    return _paymentCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => PaymentType.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }
}
