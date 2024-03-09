import 'package:bilfind_app/models/helper/auth_validation_errors.dart';
import 'package:bilfind_app/models/response/login_response.dart';
import 'package:bilfind_app/screens/auth/auth_screen.dart';
import 'package:bilfind_app/screens/auth/widgets/auth_input.dart';
import 'package:bilfind_app/screens/profile_page/profile_page_screen.dart';
import 'package:bilfind_app/screens/search/search_screen.dart';
import 'package:bilfind_app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_theme.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/app_button.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({Key? key, required this.changeAuth}) : super(key: key);

  final Function(int, String?) changeAuth;

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  AuthValidationErrors authValidationErrors = AuthValidationErrors();
  LoginResponse loginResponse = LoginResponse();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Login",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                AuthInput(
                    textController: emailController,
                    validationError: authValidationErrors.email,
                    serverError: loginResponse.emailError,
                    text: "E-mail"),
                const SizedBox(
                  height: 4,
                ),
                AuthInput(
                    textController: passwordController,
                    validationError: authValidationErrors.password,
                    serverError: loginResponse.passwordError,
                    isPass: true,
                    text: "Password"),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      widget.changeAuth(AuthScreen.forgetPassword, "");
                    },
                    child: Text(
                      "Forget Password",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : Container(
                        width: double.infinity,
                        child: AppButton(
                          label: "Login",
                          onPressed: loginHandler,
                        ),
                      ),
                const SizedBox(height: 72),
                InkWell(
                  onTap: () {
                    widget.changeAuth(
                        AuthScreen.registerForm, emailController.text);
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Don't you have an account? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondary,
                          ),
                        ),
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  loginHandler() async {
    setState(() {
      authValidationErrors = Validator().validateLogin(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    });

    if (authValidationErrors.valid) {
      setState(() {
        isLoading = true;
      });
      loginResponse = await AuthService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      setState(() {
        isLoading = false;
      });

      if (loginResponse.isValid) {
        print("Logged in");
        context.go("/search");
      }
    }
  }
}
