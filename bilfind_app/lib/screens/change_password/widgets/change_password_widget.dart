import 'package:bilfind_app/screens/auth/widgets/auth_input.dart';
import 'package:bilfind_app/screens/profile_page/profile_page_screen.dart';
import 'package:bilfind_app/services/auth_service.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/app_button.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({Key? key}) : super(key: key);

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  bool isLoading = false;

  String? oldPasswordError;
  String? newPasswordError;
  String? rePasswordError;

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
                    "Change Password",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                AuthInput(
                    textController: oldPasswordController,
                    isPass: true,
                    validationError: oldPasswordError,
                    text: "Old Password"),
                AuthInput(
                    textController: passwordController,
                    isPass: true,
                    validationError: newPasswordError,
                    text: "New Password"),
                const SizedBox(
                  height: 4,
                ),
                AuthInput(
                    textController: rePasswordController,
                    isPass: true,
                    validationError: rePasswordError,
                    text: "New Password Again"),
                const SizedBox(
                  height: 24,
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: "Change Password",
                          onPressed: onChangePasswordClicked,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onChangePasswordClicked() async {
    if (validate()) {
      setState(() {
        isLoading = true;
      });

      bool result = await AuthService.changePassword(
          oldPassword: oldPasswordController.text,
          newPassword: passwordController.text);

      if (result) {
        context.go(RouteGenerator().profileRoute);
        await Future.delayed(const Duration(milliseconds: 300));
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Password successfully updated!",
            ),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 1300),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
          oldPasswordError = "Old password is not correct.";
        });
      }
    }
  }

  bool validate() {
    oldPasswordError = Validator.validatePassword(oldPasswordController.text);
    newPasswordError = Validator.validatePassword(passwordController.text);
    rePasswordError = Validator.validatePassword(rePasswordController.text);

    if (rePasswordError == null &&
        rePasswordController.text != passwordController.text) {
      rePasswordError = "Passwords do not match!";
    }

    if (oldPasswordError == null &&
        newPasswordError == null &&
        passwordController.text == oldPasswordController.text) {
      newPasswordError = "New password should not be same with old one!";
    }

    setState(() {});
    return ![oldPasswordError, newPasswordError, rePasswordError]
        .any((error) => error != null);
  }
}
