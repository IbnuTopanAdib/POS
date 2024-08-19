// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class ReadOrderEvent extends OrderEvent {}

class LoadOrderEvent extends OrderEvent {
  final List<OrderModel> orders;
  final List<Product?> products;
  const LoadOrderEvent(this.orders, this.products);

  @override
  List<Object> get props => [orders];
}

class FilterOrdersEvent extends OrderEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final num? minPrice;
  final num? maxPrice;
  final String? category;

  const FilterOrdersEvent({
    this.startDate,
    this.endDate,
    this.minPrice,
    this.maxPrice,
    this.category,
  });

  @override
  List<Object?> get props => [startDate, endDate, minPrice, maxPrice, category];
}

class ClearFilterEvent extends OrderEvent {}