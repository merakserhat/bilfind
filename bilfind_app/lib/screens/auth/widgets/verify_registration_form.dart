import 'package:bilfind_app/models/helper/auth_validation_errors.dart';
import 'package:bilfind_app/models/response/register_response.dart';
import 'package:bilfind_app/screens/add_profile_photo/add_profile_photo_screen.dart';
import 'package:bilfind_app/screens/auth/auth_screen.dart';
import 'package:bilfind_app/screens/post_detail/post_detail_screen.dart';
import 'package:bilfind_app/screens/profile_page/profile_page_screen.dart';
import 'package:bilfind_app/screens/search/search_screen.dart';
import 'package:bilfind_app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../../../constants/app_theme.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/app_button.dart';

class VerifyRegistrationForm extends StatefulWidget {
  const VerifyRegistrationForm({
    Key? key,
    required this.changeAuth,
    required this.email,
    this.isRegister = true,
  }) : super(key: key);

  final Function(int, String?, {String? resetToken}) changeAuth;
  final String email;
  final bool isRegister;

  @override
  State<VerifyRegistrationForm> createState() => _VerifyRegistrationFormState();
}

class _VerifyRegistrationFormState extends State<VerifyRegistrationForm> {
  bool isLoading = false;

  String error = "";
  String code = "";

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
                      "Enter Verification Code",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    _getDetailText(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  FittedBox(
                    child: OtpTextField(
                      numberOfFields: 6,
                      fieldWidth: 50,
                      borderColor: Color(0xFF512DA8),
                      showFieldAsBox: true,
                      onSubmit: (String verificationCode) {
                        setState(() {
                          code = verificationCode;
                        });
                        verifyHandler();
                      }, // end onSubmit
                    ),
                  ),
                  error.length != 0
                      ? Text(
                          error,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.red),
                        )
                      : Container(),
                  const SizedBox(
                    height: 48,
                  ),
                  isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            label: "Verify",
                            onPressed: verifyHandler,
                          ),
                        ),
                  const SizedBox(height: 72),
                  InkWell(
                    onTap: () {
                      // TODO: sent again
                    },
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
    if (code.length == 6) {
      setState(() {
        isLoading = true;
      });
      bool verified = false;
      String? resetToken;

      if (widget.isRegister) {
        verified = await AuthService.verifyRegistrationCode(
            email: widget.email, code: code);
      } else {
        resetToken = await AuthService.verifyResetPasswordCode(
            email: widget.email, code: code);
        verified = resetToken != null;
      }

      setState(() {
        isLoading = false;
      });

      if (verified) {
        if (widget.isRegister) {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (_) => const AddProfilePhotoScreen()));
          await Future.delayed(const Duration(milliseconds: 300));
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
        } else {
          widget.changeAuth(
            AuthScreen.resetPassword,
            widget.email,
            resetToken: resetToken,
          );
        }
      } else {
        error = "Verification code is not valid.";
      }
    } else {
      setState(() {
        error = "Verification code must be 6 digits.";
      });
    }
  }

  String _getDetailText() {
    if (widget.isRegister) {
      return "Enter the verification code that we sent to ${widget.email} in order to verify your account.";
    }

    return "Enter the verification code that we sent to ${widget.email} in order to reset your password.";
  }
}
