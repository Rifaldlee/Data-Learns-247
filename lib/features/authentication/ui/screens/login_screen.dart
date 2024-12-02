import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/authentication/cubit/login_cubit.dart';
import 'package:data_learns_247/features/authentication/data/dto/login_request_payload.dart';
import 'package:data_learns_247/shared_ui/widgets/asset_stack_bg_image.dart';
import 'package:data_learns_247/shared_ui/widgets/custom_form_field.dart';
import 'package:data_learns_247/shared_ui/widgets/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                AssetStackBgImage(
                  assetImgDir: "assets/img/img_bg_sign_in.png",
                  height: 420 + MediaQuery.of(context).viewPadding.top),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 142,
                        height: 30,
                        margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 24, bottom: 24),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage("assets/img/logo_data_learns.png")
                          )
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 251,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/img/img_ill_2.png")
                          )
                        ),
                      ),
                      Text(
                        "Sign in",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: kBlackColor)
                      ),
                      const SizedBox(height: 2),
                      toSignUpText(),
                      const SizedBox(height: 20),
                      signInForm(),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget signInForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomFormField(
              isRequired: true,
              fieldName: "Email",
              controller: _emailController,
              textInputType: TextInputType.emailAddress,
              hintText: "Alamat email anda",
              margin: const EdgeInsets.only(bottom: 20),
              validator: (value) {
                if (!value!.contains('@')) {
                  return "Email tidak valid";
                }
                return null;
              },
            ),
            CustomFormField(
              isRequired: true,
              fieldName: "Password",
              controller: _passwordController,
              useToggleVisibility: true,
              hintText: "Password anda",
              textInputType: TextInputType.visiblePassword,
              margin: const EdgeInsets.only(bottom: 20),
            ),
            const SizedBox(height: 30),
            signInButton(),
          ],
        ),
      ),
    );
  }

  Widget signInButton() {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginCompleted) {
          context.goNamed(RouteConstants.mainFrontPage);
        }
        else if (state is LoginError) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
            direction: TextDirection.ltr,
            alignment: Alignment.bottomCenter,
            closeButtonShowType: CloseButtonShowType.always,
            showIcon: true,
            dragToClose: true,
            autoCloseDuration: const Duration(seconds: 5),
              title: const Text('Login Unsuccessful'),
            description: RichText(text: TextSpan(text: state.message)),
            icon: const Icon(Icons.remove_circle_outline),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16
            ),
            borderRadius: BorderRadius.circular(12),
          );
        }
      },
      builder: (context, state) {
        if(state is LoginLoading){
          return const Center(
              child: CircularProgressIndicator(
              color: kGreenColor,
              backgroundColor: kWhiteColor,
            ),
          );
        }
        return GradientButton(
          buttonTitle: "Sign In",
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<LoginCubit>().login(
                LoginRequestPayload(
                  email: _emailController.text,
                  password: _passwordController.text
                )
              );
            }
          }
        );
      }
    );
  }

  Widget toSignUpText() {
    return Text.rich(
      TextSpan(
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: kLightGreyColor
        ),
        children: [
          const TextSpan(text: "Sign up a new account "),
          TextSpan(
            text: "Sign up",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: kGreenColor
            ),
            recognizer: TapGestureRecognizer()..onTap = () {
              context.pushNamed(RouteConstants.register);
            }
          ),
        ]
      )
    );
  }
}