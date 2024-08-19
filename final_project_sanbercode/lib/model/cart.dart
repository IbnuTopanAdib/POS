class Cart {
  String? id; 
  String? productId; 
  int? quantity; 

  Cart({
    required this.id,
    required this.productId,
    required this.quantity,
  });


  factory Cart.fromJson(Map<String, dynamic> json, String id) {
    return Cart(
      id: id,
      productId: json['product_id'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    return data;
  }
}
