part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props => [message];
}


class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class AuthUserLoaded extends AuthState {
  final UserProfile user;
  const AuthUserLoaded(this.user);
  @override
  List<Object?> get props => [user];
}

class Authenticated extends AuthState {


  const Authenticated();
  @override
  List<Object?> get props => [];
}

class Unauthenticated extends AuthState {
  @override
  List<Object> get props => [];
}

class OnboardingRequired extends AuthState {
  @override
  List<Object> get props => [];
}


