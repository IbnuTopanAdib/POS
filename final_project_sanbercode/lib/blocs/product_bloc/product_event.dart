// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();
}

class LoadProducts extends ProductEvent {
  final List<Product> products;
  const LoadProducts(
    this.products,
  );
  @override
  List<Object> get props => [];
}

class ReadDataProduct extends ProductEvent {
  @override
  List<Object> get props => [];
}

class LoadProductById extends ProductEvent {
  final String id;

  const LoadProductById(this.id);

  @override
  List<Object> get props => [id];
}

class SearchProduct extends ProductEvent {
  final String query;

  const SearchProduct(this.query);

  @override
  List<Object?> get props => [query];
}

class UpdateProduct extends ProductEvent {
  final Product product;

  const UpdateProduct(this.product);

  @override
  List<Object> get props => [product];
}

class AddProduct extends ProductEvent {
  final Product product;

  const AddProduct(this.product);

  @override
  List<Object> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final String productId;

  const DeleteProduct(this.productId);

  @override
  List<Object> get props => [productId];
}
