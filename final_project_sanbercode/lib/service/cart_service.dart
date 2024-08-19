import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_sanbercode/model/cart.dart';

class CartService {
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection('carts');

  Stream<List<Cart>> getAllCartsStream() {
    return _cartCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Cart.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addProductToCart(String productId, int quantity) async {
    try {
      QuerySnapshot query =
          await _cartCollection.where('product_id', isEqualTo: productId).get();
      if (query.docs.isEmpty) {
        await _cartCollection.add({
          'product_id': productId,
          'quantity': quantity,
        });
      } else {
        DocumentSnapshot doc = query.docs.first;
        int currentQuantity = doc['quantity'];
        await _cartCollection.doc(doc.id).update({
          'quantity': currentQuantity + quantity,
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> decreaseQuantity(String cartId) async {
    try {
      DocumentReference cartRef = _cartCollection.doc(cartId);
      DocumentSnapshot doc = await cartRef.get();

      if (doc.exists) {
        int currentQuantity = doc['quantity'];
        if (currentQuantity > 1) {
          await cartRef.update({'quantity': currentQuantity - 1});
        } else {
          await cartRef.delete();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> increaseQuantity(String cartId) async {
    try {
      DocumentReference cartRef = _cartCollection.doc(cartId);
      DocumentSnapshot doc = await cartRef.get();

      if (doc.exists) {
        int currentQuantity = doc['quantity'];
        await cartRef.update({'quantity': currentQuantity + 1});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCartItem(String cartId) async {
    try {
      await _cartCollection.doc(cartId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> clearCart() async {
    try {
      QuerySnapshot querySnapshot = await _cartCollection.get();
      for (var doc in querySnapshot.docs) {
        await _cartCollection.doc(doc.id).delete();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteSelectedCarts(List<String> selectedProductIds) async {
    try {
      for (var productId in selectedProductIds) {
        QuerySnapshot query = await _cartCollection
            .where('product_id', isEqualTo: productId)
            .get();
        for (var doc in query.docs) {
          await _cartCollection.doc(doc.id).delete();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<int> getTotalQuantityStream() {
    return _cartCollection.snapshots().map((snapshot) {
      return snapshot.docs.fold<int>(0, (total, doc) {
        return total + (doc['quantity'] as int);
      });
    });
  }
}
