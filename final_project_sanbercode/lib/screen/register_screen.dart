import 'package:final_project_sanbercode/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_project_sanbercode/blocs/auth_bloc/auth_bloc.dart';
import 'package:final_project_sanbercode/const/palllete.dart';

import 'package:final_project_sanbercode/widgets/button_primary.dart';
import 'package:final_project_sanbercode/widgets/custom_form_field.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Pallete.whiteColor,
        title: const Text(
          'Register',
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

          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Column(
                      children: [
                        CustomFormField(
                            text: 'Name', controller: nameController),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                            text: 'Email', controller: emailController),
                        const SizedBox(
                          height: 10,
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: IntlPhoneField(
                            controller: phoneNumberController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: 'ID',
                          ),
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
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty &&
                                nameController.text.isNotEmpty) {
                              context
                                  .read<AuthBloc>()
                                  .add(AuthRegisterRequested(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    name: nameController.text.trim(),
                                    phoneNumber:
                                        phoneNumberController.text.trim(),
                                  ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                ),
                              );
                            }
                          },
                          text: 'Register',
                          size: const Size(200, 50),
                        )
                      ],
                    ),
                  ),
                ),
                _loginAccountLink(context)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _loginAccountLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("Do have an account?",
            style: TextStyle(color: Pallete.primary)),
        const SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          child: const Text("Login",
              style: TextStyle(
                  color: Pallete.primary, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
