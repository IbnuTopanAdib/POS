part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {}

class CartLoading extends CartState {}

final class CheckoutState extends CartState {
  final List<Cart> carts;
  final List<Product> products;

  final num selectedTotalPrice;
  final List<String> selectedProductIds;
  final String? paymentMethod;

  const CheckoutState(
    this.carts,
    this.products,
  {
    this.selectedTotalPrice = 0.0,
    this.selectedProductIds = const [],
    this.paymentMethod,
  });

  CheckoutState copyWith({
    List<Cart>? carts,
    List<Product>? products,
    num? selectedTotalPrice,
    List<String>? selectedProductIds,
    String? paymentMethod,
  }) {
    return CheckoutState(
      carts ?? this.carts,
      products ?? this.products,
      selectedTotalPrice: selectedTotalPrice ?? this.selectedTotalPrice,
      selectedProductIds: selectedProductIds ?? this.selectedProductIds,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object?> get props =>
      [carts, products, selectedTotalPrice, selectedProductIds, paymentMethod];
}

class OrderPlaced extends CartState {
  final List<Map<String, dynamic>> productData;
  final num totalPrice;

  const OrderPlaced(this.productData, this.totalPrice);
  @override
  List<Object?> get props => [productData, totalPrice];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}
