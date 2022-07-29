import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/layout/socialApp/socialLayout.dart';
import 'package:flutter_application_2/modules/Social_app/login/cubit/cubit.dart';
import 'package:flutter_application_2/modules/Social_app/login/cubit/states.dart';
import 'package:flutter_application_2/modules/Social_app/social_register/register_social_screen.dart';

import 'package:flutter_application_2/shared/components/components.dart';
import 'package:flutter_application_2/shared/components/constants.dart';
import 'package:flutter_application_2/shared/network/local/cache_helper.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class SocialLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginErrorState) {
            print(state.error.toString());
            showToast(msg: state.error, state: ToastStates.ERROR);
          }
          if (state is SocialLoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              if (value) {
                uId = state.uId;
                navigateAndFinish(context, SocialLayout());
              }
            }).catchError((error) {
              print(error.toString());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Login now to communicate with friends',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormFaild(
                          controller: emailController,
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                          type: TextInputType.emailAddress,
                          onSubmitted: (value) {
                            print(value);
                          },
                          onChanged: (value) {
                            print(value);
                          },
                          onTap: () {
                            print('enter your email address');
                          },
                          validated: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please Enter your email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormFaild(
                          controller: passwordController,
                          label: 'Password',
                          prefix: Icons.lock_outline,
                          type: TextInputType.visiblePassword,
                          validated: (String? value) {
                            if (value!.isEmpty) {
                              return 'Password is short';
                            }
                            return null;
                          },
                          onSubmitted: (value) {
                            print(value);
                            if (formKey.currentState!.validate()) {
                              print(emailController.text);
                              print(passwordController.text);
                              SocialLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          onChanged: (value) {
                            print(value);
                          },
                          isObscure: SocialLoginCubit.get(context).isPassword,
                          suffix: SocialLoginCubit.get(context).suffix,
                          onSuffix: () {
                            SocialLoginCubit.get(context)
                                .changePasswordVisibillity();
                          },
                          onTap: () {
                            print('enter the password');
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        BuildCondition(
                          condition: state is! SocialLoginLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  print(emailController.text);
                                  print(passwordController.text);
                                  SocialLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: 'login'),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?'),
                            defaultTextButton(
                                function: () {
                                  navigateTo(context, RegisterSocialScreen());
                                },
                                text: 'register'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
