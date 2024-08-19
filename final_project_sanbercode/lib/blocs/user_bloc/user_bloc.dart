import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_project_sanbercode/model/user_profile.dart';
import 'package:final_project_sanbercode/service/auth_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
    StreamSubscription<UserProfile?>? _userProfileSubscription;
    final AuthService authService = AuthService();
  UserBloc() : super(UserInitial()) {
    on<ReadUserData>((event, emit) async {
      emit(UserLoading());
      try {
        _userProfileSubscription?.cancel();
        _userProfileSubscription =
            authService.getUserProfileStream().listen((userProfile) {
          if (userProfile != null) {
            add(LoadUser(profile: userProfile));
          }
        });
      } catch (e) {
        emit(UserError());
      }
    });

    on<LoadUser>((event, emit) {
      emit(UserLoaded(profile: event.profile));
    });
  }
}
