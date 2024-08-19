part of 'count_cart_cubit.dart';

sealed class CountCartState extends Equatable {
  const CountCartState();

  @override
  List<Object> get props => [];
}

final class CountCartInitial extends CountCartState {}

class TotalQuantityLoaded extends CountCartState {
  final int totalQuantity;

  const TotalQuantityLoaded(this.totalQuantity);

  @override
  List<Object> get props => [totalQuantity];
}

class TotalQuantityError extends CountCartState {
  final String errorMessage;

  const TotalQuantityError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}