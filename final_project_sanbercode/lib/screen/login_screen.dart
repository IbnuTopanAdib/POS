import 'package:final_project_sanbercode/blocs/auth_bloc/auth_bloc.dart';
import 'package:final_project_sanbercode/blocs/product_bloc/product_bloc.dart';
import 'package:final_project_sanbercode/blocs/user_bloc/user_bloc.dart';
import 'package:final_project_sanbercode/const/palllete.dart';
import 'package:final_project_sanbercode/screen/main_screen.dart';
import 'package:final_project_sanbercode/screen/register_screen.dart';
import 'package:final_project_sanbercode/widgets/button_primary.dart';
import 'package:final_project_sanbercode/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Pallete.whiteColor,
          title: const Text(
            'Login',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Pallete.primary),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                  ),
                ),
              );
            }

            if (state is Authenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('success'),
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
                (route) => false,
              );
              context.read<UserBloc>().add(ReadUserData());
              context.read<ProductBloc>().add(ReadDataProduct());
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logo.png'),
                      radius: 60,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        CustomFormField(
                            text: 'Email', controller: emailController),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                          text: 'Password',
                          controller: passwordController,
                          isObscured: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ButtonPrimary(
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthLoginRequested(
                                email: emailController.text,
                                password: passwordController.text));
                          },
                          text: 'Login',
                          size: const Size(200, 50),
                        )
                      ],
                    ),
                  ),
                  _registerAccountLink(context)
                ],
              ),
            );
          },
        ));
  }

  Widget _registerAccountLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Pallete.primary)),
        const SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const RegisterScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  final tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
          child: const Text("Register",
              style: TextStyle(
                  color: Pallete.primary, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
