import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:porkinio/app/common/utils/custom_form_field_validator.dart';
import 'package:porkinio/app/common/widgets/custom_auth_dialog.dart';
import 'package:porkinio/app/common/widgets/custom_flat_button.dart';
import 'package:porkinio/app/features/sign_in/sign_in_page.dart';
import 'package:porkinio/app/features/sign_up/sign_up_controller.dart';
import 'package:porkinio/app/features/sign_up/sign_up_state.dart';
import 'package:porkinio/app/common/widgets/custom_form_field.dart';
import 'package:porkinio/app/common/widgets/password_form_field.dart';
import 'package:porkinio/app/common/themes/app_colors.dart';
import 'package:porkinio/locator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const route = '/sign-up-page';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _controller = locator.get<SignUpController>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () {
        if (_controller.state is SignUpLoadingState) {
          showDialog(
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (_controller.state is SignUpSucessState) {
          customAuthDialog(
              context,
              'User registered successfully! Click below to Sign-in to your account',
              'Sign-in',
              SignInPage.route);
        }
        if (_controller.state is SignUpErrorState) {
          final error = (_controller.state as SignUpErrorState).message;
          customAuthDialog(context, error, 'Sign-in', SignUpPage.route);
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: Colors.white,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            'Create a new account',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(
                                    color: Theme.of(context).primaryColorDark),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        CustomFormField(
                          validator: CustomFormFieldValidator.validateName,
                          labelText: 'Full Name',
                          controller: _nameController,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        CustomFormField(
                          validator: CustomFormFieldValidator.validateEmail,
                          labelText: 'E-mail',
                          controller: _emailController,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        PasswordFormField(
                          labelText: 'Password',
                          validator: CustomFormFieldValidator.validatePassword,
                          controller: _passwordController,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        PasswordFormField(
                          labelText: 'Password Confirmation',
                          validator: (value) =>
                              CustomFormFieldValidator.confirmValidatePassword(
                                  _passwordController.text, value),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Center(
                          child: Text(
                            'By creating an account, you confirm to agree \nwith our Terms of Services and Privacy Policy.',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              CustomFlatButton(
                text: 'CONFIRM',
                color: AppColors.primaryDark,
                width: 0.9,
                height: 0.06,
                fontSize: 20,
                textColor: Colors.white,
                onPressed: () {
                  final valid = _formKey.currentState != null &&
                      _formKey.currentState!.validate();

                  if (valid) {
                    _controller.doSignUp(
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                  } else {
                    log('Something went wrong. Please check your data and try again in a few moments.');
                  }
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(SignInPage.route);
                },
                child: const Center(
                  child: Text(
                    'Return to the sign-in page',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
