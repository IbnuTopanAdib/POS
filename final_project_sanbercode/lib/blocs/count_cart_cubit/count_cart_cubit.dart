import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_project_sanbercode/service/cart_service.dart';

part 'count_cart_state.dart';

class CountCartCubit extends Cubit<CountCartState> {
  final CartService _cartService = CartService();

  CountCartCubit() : super(CountCartInitial()) {
    _cartService.getTotalQuantityStream().listen((totalQuantity) {
      emit(TotalQuantityLoaded(totalQuantity));
    });
  }
}
