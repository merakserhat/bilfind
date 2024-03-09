import 'package:bilfind_app/screens/auth/widgets/forget_password_form.dart';
import 'package:bilfind_app/screens/auth/widgets/login_form.dart';
import 'package:bilfind_app/screens/auth/widgets/register_form.dart';
import 'package:bilfind_app/screens/auth/widgets/reset_password_form.dart';
import 'package:bilfind_app/screens/auth/widgets/verify_registration_form.dart';
import 'package:bilfind_app/utils/routing/custom_route.dart';
import 'package:bilfind_app/widgets/app_bar/basic_app_bar.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';

class AuthScreen extends StatefulWidget {
  static const int registerForm = 0;
  static const int loginForm = 1;
  static const int registerVerificationForm = 2;
  static const int forgetPassword = 3;
  static const int resetPassword = 4;

  const AuthScreen({Key? key}) : super(key: key);
  static CustomRoute customRoute = CustomRoute(route: "/auth");

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int formType = AuthScreen.loginForm;
  String? verificationEmail = "";
  String? resetToken = "";
  bool isRegister = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: ((Theme.of(context).brightness == Brightness.dark)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            .copyWith(
          statusBarColor: Theme.of(context).colorScheme.background,
        ),
        child: Responsive(
          mobile: getMobileLayout(),
          tablet: getMobileLayout(),
          desktop: getDesktopLayout(),
        ),
      ),
    );
  }

  Widget getMobileLayout() {
    return Column(
      children: [
        const BasicAppBar(),
        Expanded(
          child: getForm(),
        ),
      ],
    );
  }

  Widget getDesktopLayout() {
    return Column(
      children: [
        const BasicAppBar(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: getForm()),
              Expanded(
                child: Image.asset(
                  "assets/images/auth_image.png",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getForm() {
    if (formType == 0) {
      return RegisterFormWidget(changeAuth: changeAuthType);
    }

    if (formType == 1) {
      return LoginFormWidget(changeAuth: changeAuthType);
    }

    if (formType == 2) {
      return VerifyRegistrationForm(
        changeAuth: changeAuthType,
        email: verificationEmail!,
        isRegister: isRegister,
      );
    }

    if (formType == 3) {
      return ForgetPasswordForm(changeAuth: changeAuthType);
    }

    return ResetPasswordForm(
        changeAuth: changeAuthType, resetToken: resetToken!);
  }

  void changeAuthType(int screenType, String? email,
      {bool? isRegister, String? resetToken}) {
    setState(() {
      formType = screenType;
      if (email != null) {
        verificationEmail = email;
      }
      if (isRegister != null) {
        this.isRegister = isRegister;
      }
      if (resetToken != null) {
        this.resetToken = resetToken;
      }
    });
  }
}
