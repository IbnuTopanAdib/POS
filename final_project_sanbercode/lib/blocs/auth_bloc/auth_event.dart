part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
  });
  @override
  List<Object> get props => [email, password, name, phoneNumber];
}

class SaveUserProfileEvent extends AuthEvent {
  final UserProfile userProfile;

  const SaveUserProfileEvent({required this.userProfile});
  @override
  List<Object> get props => [userProfile];
}

class AuthAnonymousLoginRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthLoadUser extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthUserProfileChanged extends AuthEvent {
  final UserProfile userProfile;

  const AuthUserProfileChanged(this.userProfile);

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthLogoutRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthCheckOnboarding extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthCompleteOnboarding extends AuthEvent {
  @override
  List<Object> get props => [];
}
