part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

final class OrderInitial extends OrderState {}

class OrderListLoaded extends OrderState {
  final List<OrderModel> orders;
  final List<Product?> products;

  const OrderListLoaded(this.orders, this.products);

  OrderListLoaded copyWith({
    List<OrderModel>? orders,
    List<Product?>? products,
  }) {
    return OrderListLoaded(
      orders ?? this.orders,
      products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [orders, products];
}

class OrderListLoading extends OrderState {}

class OrderListError extends OrderState {
  final String message;
  const OrderListError(this.message);
  @override
  List<Object> get props => [message];
}
