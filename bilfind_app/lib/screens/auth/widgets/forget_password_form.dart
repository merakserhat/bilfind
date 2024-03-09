import 'package:bilfind_app/models/helper/auth_validation_errors.dart';
import 'package:bilfind_app/models/response/login_response.dart';
import 'package:bilfind_app/models/response/register_response.dart';
import 'package:bilfind_app/screens/auth/auth_screen.dart';
import 'package:bilfind_app/screens/auth/widgets/auth_input.dart';
import 'package:bilfind_app/screens/post_detail/post_detail_screen.dart';
import 'package:bilfind_app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../../../constants/app_theme.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/app_button.dart';

class ForgetPasswordForm extends StatefulWidget {
  const ForgetPasswordForm({Key? key, required this.changeAuth})
      : super(key: key);

  final Function(int, String?, {bool? isRegister}) changeAuth;

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  bool isLoading = false;

  String? emailError;
  String code = "";

  TextEditingController emailController = TextEditingController();
  AuthValidationErrors authValidationErrors = AuthValidationErrors();
  LoginResponse loginResponse = LoginResponse();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 360,
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Reset Password",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Enter your email to reset your password.",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  AuthInput(
                    textController: emailController,
                    validationError: authValidationErrors.email,
                    serverError: emailError,
                    text: "E-mail",
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            label: "Send Reset Link",
                            onPressed: verifyHandler,
                          ),
                        ),
                  const SizedBox(height: 72),
                  InkWell(
                    onTap: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Did not receive code? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(
                          "Sent Again",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  verifyHandler() async {
    if (!validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    bool success =
        await AuthService.getResetPasswordOtp(email: emailController.text);

    if (!success) {
      setState(() {
        isLoading = false;
      });

      emailError = "This email is not registered to Bilfind.";
    } else {
      widget.changeAuth(
        AuthScreen.registerVerificationForm,
        emailController.text,
        isRegister: false,
      );
    }
  }

  bool validate() {
    setState(() {
      emailError = Validator.validateEmail(emailController.text);
    });
    return emailError == null;
  }
}
