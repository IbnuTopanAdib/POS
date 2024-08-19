import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_project_sanbercode/model/user_profile.dart';
import 'package:final_project_sanbercode/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService = AuthService();
  StreamSubscription<UserProfile?>? _userProfileSubscription;

  AuthBloc() : super(AuthInitial()) {
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthCheckOnboarding>(_onAuthCheckOnboarding);
    on<AuthCompleteOnboarding>(_onAuthCompleteOnboarding);
  }

  Future<void> _onAuthRegisterRequested(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final email = event.email;
    final password = event.password;
    final name = event.name;
    final phoneNumber = event.phoneNumber;

    // Validasi regex untuk email
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      emit(const AuthError("Invalid email format"));
      return;
    }

    // Validasi password (minimal 6 karakter, harus mengandung huruf dan angka)
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
    if (!passwordRegex.hasMatch(password)) {
      emit(const AuthError(
          "Password must be at least 6 characters long and include both letters and numbers"));
      return;
    }

    final isRegisterSuccess = await authService.register(
      email: email,
      password: password,
      name: name,
      phoneNumber: phoneNumber,
    );
    if (isRegisterSuccess) {
      emit(const AuthSuccess("Register successfully"));
    } else {
      emit(const AuthError("Register failed"));
    }
  }

  Future<void> _onAuthLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final isLoginSuccess =
        await authService.login(event.email, event.password);
    if (isLoginSuccess) {
      emit(const Authenticated());
    } else {
      emit(const AuthError("Login failed"));
    }
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      emit(const Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onAuthLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await authService.logout();
    emit(Unauthenticated());
  }

  Future<void> _onAuthCheckOnboarding(
      AuthCheckOnboarding event, Emitter<AuthState> emit) async {
    final isComplete = await authService.isOnboardingComplete();
    if (isComplete) {
      add(AuthCheckRequested());
    } else {
      emit(OnboardingRequired());
    }
  }

  Future<void> _onAuthCompleteOnboarding(
      AuthCompleteOnboarding event, Emitter<AuthState> emit) async {
    await authService.completeOnboarding();
    add(AuthCheckRequested());
  }

  @override
  Future<void> close() {
    _userProfileSubscription?.cancel();
    return super.close();
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
