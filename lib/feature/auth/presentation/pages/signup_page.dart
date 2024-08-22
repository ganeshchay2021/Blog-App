import 'package:blogapp/core/common/widgets/loader.dart';
import 'package:blogapp/core/utils/show_snackbar.dart';
import 'package:blogapp/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogapp/feature/auth/presentation/pages/login_page.dart';
import 'package:blogapp/feature/auth/presentation/widgets/auth_gradent_button.dart';
import 'package:blogapp/feature/auth/presentation/widgets/auth_login_signup_btn.dart';
import 'package:blogapp/feature/auth/presentation/widgets/auth_textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      );
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //form key
  final _formKey = GlobalKey<FormState>();

  //texteditiing controller
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //controller disposed
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        //Sign Up Form
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthErrorState) {
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
                  const SizedBox(
                    height: 100,
                  ),
                  //header text
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //textfiled for Name
                  AuthTextField(
                    controller: nameController,
                    hintText: "Name",
                    validator: (value) {
                      //Validating Name Field
                      if (value == null || value.isEmpty) {
                        return "Name is Missing";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //textfiled for Email
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
                  //textfiled for password
                  AuthTextField(
                    controller: passwordController,
                    obscureText: true,
                    hintText: "Password",
                    validator: (value) {
                      //validating Password Field
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
                  //signup button
                  AuthGradientButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(AuthSignUpEvent(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),),);
                      }
                    },
                    btnText: "Sign Up",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Footer text and Textbutton
                  AuthLoginSignUp(
                    onTap: () {
                      Navigator.pushReplacement(context, LoginPage.route());
                    },
                    text: "Already have an account?",
                    textBtn: "Login",
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
