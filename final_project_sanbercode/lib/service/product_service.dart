import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_sanbercode/model/product.dart';

class ProductService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late final CollectionReference _productCollection =
      _firebaseFirestore.collection('products');

  Stream<List<Product>> getProducts() {
    return _productCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<Product> getProductById(String productId) async {
    try {
      DocumentSnapshot doc = await _productCollection.doc(productId).get();
      return Product.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Product>> getProductsByIds(List<int> ids) async {
    if (ids.isEmpty) return [];

    final snapshot = await _productCollection.where('id', whereIn: ids).get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Product.fromJson(data, doc.id);
    }).toList();
  }

  Future<void> addProduct(Product product) async {
    final docRef = _productCollection.doc();
    product.id = docRef.id;
    await docRef.set(product.toJson());
  }

  Future<void> updateProduct(Product product) {
    return _productCollection.doc(product.id).update(product.toJson());
  }

  Future<void> deleteProduct(String productId) {
    return _productCollection.doc(productId).delete();
  }

  Future<void> decreaseProductStock(String productId, int quantity) async {
    try {
      DocumentSnapshot doc = await _productCollection.doc(productId).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        int currentStock = data['stock'] as int? ?? 0;

        int newStock = currentStock - quantity;

        if (newStock < 0) newStock = 0;
        
        await _productCollection.doc(productId).update({'stock': newStock});
      }
    } catch (e) {
      print('Error decreasing stock: $e');
      rethrow;
    }
  }

   Future<List<Product>> searchProducts(String query) async {
    try {
      final snapshot = await _productCollection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Product.fromJson(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error searching products: $e');
      rethrow;
    }
  }
}
