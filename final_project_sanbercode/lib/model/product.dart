class Product {
  String id;
  String name;
  String description;
  num price;
  String imageURL;
  String category;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageURL,
    required this.category,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json, String id) {
    return Product(
      id: id,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'] as num? ?? 0,
      category: json['category'] as String? ?? '',
      imageURL: json['imageURL'] as String? ?? '',
      stock: json['stock'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;

    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['imageURL'] = imageURL;
    data['category'] = category;
    data['stock'] = stock;
    return data;
  }
}
