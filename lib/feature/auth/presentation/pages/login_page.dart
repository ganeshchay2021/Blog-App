import 'package:blogapp/core/common/widgets/loader.dart';
import 'package:blogapp/core/utils/show_snackbar.dart';
import 'package:blogapp/dashboard.dart';
import 'package:blogapp/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogapp/feature/auth/presentation/pages/signup_page.dart';
import 'package:blogapp/feature/auth/presentation/widgets/auth_gradent_button.dart';
import 'package:blogapp/feature/auth/presentation/widgets/auth_login_signup_btn.dart';
import 'package:blogapp/feature/auth/presentation/widgets/auth_textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Form Key
  final _formKey = GlobalKey<FormState>();

  //Textediting controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Controller Disposed
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        //Login Form section
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                ),
              );
            } else if (state is AuthErrorState) {
              showSnakBar(context, state.message, Colors.red);
            }
          },
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const Loader();
            }
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Header text
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  //Textfield for Email
                  AuthTextField(
                    controller: emailController,
                    hintText: "Email",
                    validator: (value) {
                      //Validating Email Field
                      if (value == null || value.isEmpty) {
                        return "Email is Missing";
                      } else if (EmailValidator.validate(value)) {
                        return null;
                      } else {
                        return "Invalid email address";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //Textfield for Password
                  AuthTextField(
                    controller: passwordController,
                    obscureText: true,
                    hintText: "Password",
                    validator: (value) {
                      //validating Password field
                      if (value == null || value.isEmpty) {
                        return "Password is Missing";
                      } else if (value.length < 8) {
                        return "Password must be exceeds 8 characters";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  //login button
                  AuthGradientButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthLoginEvent(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                      }
                    },
                    btnText: "Login",
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  //Footer text and Textbutton
                  AuthLoginSignUp(
                    onTap: () {
                      Navigator.push(
                        context,
                        SignUpPage.route(),
                      );
                    },
                    text: "Don't have an account? ",
                    textBtn: "Sign Up",
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
