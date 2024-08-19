part of 'payment_list_cubit.dart';

sealed class PaymentListState extends Equatable {
  const PaymentListState();

  @override
  List<Object> get props => [];
}

final class PaymentListInitial extends PaymentListState {}

class PaymentListLoaded extends PaymentListState {
  final List<PaymentType> paymentlist;

  const PaymentListLoaded(this.paymentlist);
  @override
  List<Object> get props => [paymentlist];
}
