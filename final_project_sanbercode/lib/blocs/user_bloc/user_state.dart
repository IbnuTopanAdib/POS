part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserProfile profile;

  const UserLoaded({required this.profile});

  @override
  List<Object> get props => [profile];
}

class UserError extends UserState {}
