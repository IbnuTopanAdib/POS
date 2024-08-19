import 'package:final_project_sanbercode/blocs/auth_bloc/auth_bloc.dart';
import 'package:final_project_sanbercode/screen/main_screen.dart';
import 'package:final_project_sanbercode/screen/login_screen.dart';
import 'package:final_project_sanbercode/screen/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const MainScreen();
        } else if (state is Unauthenticated) {
          return const LoginScreen();
        } else if (state is OnboardingRequired) {
          return const OnboardingScreen();
        } else if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return const LoginScreen();
      },
    );
  }
}
