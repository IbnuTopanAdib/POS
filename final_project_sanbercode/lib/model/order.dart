class OrderModel {
  String? id;
  String? paymentMethod;
  DateTime? transactionDate;
  num? totalPrice;
  List<Map<String, dynamic>>? products;

  OrderModel({
    this.id,
    this.paymentMethod,
    this.transactionDate,
    this.totalPrice,
    this.products,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String id) {
    return OrderModel(
      id: id,
      paymentMethod: json['payment_method'] as String?,
      transactionDate: json['transactionDate'] != null
          ? DateTime.parse(json['transactionDate'] as String)
          : null,
      totalPrice: json['totalPrice'] as num?,
      products: (json['products'] as List<dynamic>?)
          ?.map((item) => item as Map<String, dynamic>)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_method': paymentMethod,
      'transactionDate': transactionDate?.toIso8601String(),
      'totalPrice': totalPrice,
      'products': products,
    };
  }
}
