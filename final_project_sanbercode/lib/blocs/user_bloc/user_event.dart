part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class ReadUserData extends UserEvent {

}

class LoadUser extends UserEvent {
  final UserProfile profile;

  const LoadUser({required this.profile});
}
