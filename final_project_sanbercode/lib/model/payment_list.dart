class PaymentMethod {
  final String name;
  final String imageLink;

  PaymentMethod({
    required this.name,
    required this.imageLink,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      name: json['name'],
      imageLink: json['imageLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageLink': imageLink,
    };
  }
}

class PaymentType {
  final String type;
  final List<PaymentMethod> methods;

  PaymentType({
    required this.type,
    required this.methods,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    var list = json['methods'] as List;
    List<PaymentMethod> methodsList =
        list.map((i) => PaymentMethod.fromJson(i)).toList();

    return PaymentType(
      type: json['type'],
      methods: methodsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'methods': methods.map((method) => method.toJson()).toList(),
    };
  }
}
