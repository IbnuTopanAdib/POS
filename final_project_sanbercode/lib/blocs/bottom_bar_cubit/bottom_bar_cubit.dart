import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


part 'bottom_bar_state.dart';

class BottomBarCubit extends Cubit<BottomBarState> {
  BottomBarCubit() : super(const BottomBarState(index: 0));

  void navigateTo({required int index}) {
    emit(BottomBarState(index: index));
  }
}
