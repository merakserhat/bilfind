import 'package:bilfind_app/screens/auth/auth_screen.dart';
import 'package:bilfind_app/screens/auth/widgets/auth_input.dart';
import 'package:bilfind_app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_theme.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/app_button.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm(
      {Key? key, required this.changeAuth, required this.resetToken})
      : super(key: key);

  final Function(int, String?) changeAuth;
  final String resetToken;

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  bool isLoading = false;

  String? passwordError;
  String? passwordAgainError;

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
                    textController: passwordController,
                    validationError: passwordError,
                    isPass: true,
                    text: "Password"),
                const SizedBox(
                  height: 4,
                ),
                AuthInput(
                    textController: passwordAgainController,
                    validationError: passwordAgainError,
                    isPass: true,
                    text: "Password Again"),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
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
                          label: "Reset Password",
                          onPressed: resetHandler,
                        ),
                      ),
                const SizedBox(height: 72),
                InkWell(
                    onTap: () {
                      widget.changeAuth(AuthScreen.loginForm, null);
                    },
                    child: const Text(
                      "Return to Login",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondary,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  resetHandler() async {
    if (validate()) {
      setState(() {
        isLoading = true;
      });

      bool resetResponse = await AuthService.resetPassword(
        resetToken: widget.resetToken,
        newPassword: passwordController.text,
      );

      setState(() {
        isLoading = false;
      });

      if (resetResponse) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Verification Successful!",
            ),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 1300),
          ),
        );
        await Future.delayed(Duration(milliseconds: 500));
        widget.changeAuth(AuthScreen.loginForm, null);
      } else {
        // TODO: here error snack
      }
    }
  }

  bool validate() {
    setState(() {
      passwordError = Validator.validatePassword(passwordController.text);
      passwordAgainError =
          Validator.validatePassword(passwordAgainController.text);
    });

    if (passwordController.text != passwordAgainController.text) {
      passwordAgainError = "Passwords are not equal.";
    }

    return passwordError == null && passwordAgainError == null;
  }
}
