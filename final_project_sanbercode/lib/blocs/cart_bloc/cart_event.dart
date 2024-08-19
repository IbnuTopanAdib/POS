part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddProductToCart extends CartEvent {
  final String productId;
  final int quantity;

  const AddProductToCart(this.productId, this.quantity);

  @override
  List<Object> get props => [productId, quantity];
}

class IncreaseQuantity extends CartEvent {
  final String cartId;

  const IncreaseQuantity(this.cartId);

  @override
  List<Object> get props => [cartId];
}

class DecreaseQuantity extends CartEvent {
  final String cartId;

  const DecreaseQuantity(this.cartId);

  @override
  List<Object> get props => [cartId];
}

class CartUpdated extends CartEvent {
  final List<Cart> carts;
  final List<Product> products;

  final List<String> selectedProductIds;

  const CartUpdated(this.carts, this.products, this.selectedProductIds);

  @override
  List<Object> get props => [carts, products];
}

class SelectProduct extends CartEvent {
  final String productId;
  final bool isSelected;

  const SelectProduct(this.productId, this.isSelected);

  @override
  List<Object?> get props => [productId, isSelected];
}

class SelectAllProducts extends CartEvent {
  final bool isSelected;

  const SelectAllProducts(this.isSelected);

  @override
  List<Object> get props => [isSelected];
}

class SelectPaymentMethod extends CartEvent {
  final String paymentMethod;

  const SelectPaymentMethod(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class CheckoutSingleProduct extends CartEvent {
  final String productId;

  const CheckoutSingleProduct(this.productId);

  @override
  List<Object> get props => [productId];
}

class ProcessPayment extends CartEvent {}

class PlaceOrder extends CartEvent {}
