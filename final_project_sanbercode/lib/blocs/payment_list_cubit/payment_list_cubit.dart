import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_project_sanbercode/model/payment_list.dart';
import 'package:final_project_sanbercode/service/payment_dummy_service.dart';

part 'payment_list_state.dart';

class PaymentListCubit extends Cubit<PaymentListState> {
  final PaymentDummyService _paymentDummyService = PaymentDummyService();
  PaymentListCubit() : super(PaymentListInitial());

  // ignore: non_constant_identifier_names
  void load_payment_list() async {
    final paymentlist = await _paymentDummyService.getPayment();
    emit(PaymentListLoaded(paymentlist));
  }


}
