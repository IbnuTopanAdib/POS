part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();
  
  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  const ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductByIdLoaded extends ProductState {
  final Product product;

  const ProductByIdLoaded(this.product);

  @override
  List<Object> get props => [product];
}

class ProductAdded extends ProductState {}

class ProductUpdated extends ProductState {}

class ProductDeleted extends ProductState {}

class ProductError extends ProductState {}

class ProductLowStock extends ProductState {
  final List<Product> lowStockProducts;

  const ProductLowStock(this.lowStockProducts);

  @override
  List<Object> get props => [lowStockProducts];
}