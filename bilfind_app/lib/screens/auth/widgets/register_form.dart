import 'package:bilfind_app/constants/enums.dart';
import 'package:bilfind_app/models/helper/auth_validation_errors.dart';
import 'package:bilfind_app/models/response/register_response.dart';
import 'package:bilfind_app/screens/auth/auth_screen.dart';
import 'package:bilfind_app/screens/auth/widgets/auth_input.dart';
import 'package:bilfind_app/screens/auth/widgets/dropdown_auth_input.dart';
import 'package:bilfind_app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_theme.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/app_button.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({Key? key, required this.changeAuth})
      : super(key: key);

  final Function(int, String?, {bool? isRegister}) changeAuth;

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  bool isLoading = false;
  Departments? _selectedDepartment;

  AuthValidationErrors authValidationErrors = AuthValidationErrors();
  RegisterResponse registerResponse = RegisterResponse();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 360),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Register",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    AuthInput(
                      textController: nameController,
                      validationError: authValidationErrors.name,
                      serverError: registerResponse.usernameError,
                      text: "Name",
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    AuthInput(
                      textController: surnameController,
                      validationError: authValidationErrors.surname,
                      serverError: registerResponse.usernameError,
                      text: "Surname",
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    AuthInput(
                        textController: emailController,
                        validationError: authValidationErrors.email,
                        serverError: registerResponse.emailError,
                        text: "E-mail"),
                    //const SizedBox(width: 22),
                    const SizedBox(
                      height: 4,
                    ),
                    DropdownAuthInput(
                      label: "Departments",
                      validationError: authValidationErrors.department,
                      serverError: registerResponse.departmentError,
                      onChanged: (Departments? selectedDepartment) {
                        setState(() {
                          _selectedDepartment = selectedDepartment;
                        });
                      },
                      selectedDepartment: _selectedDepartment,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    AuthInput(
                        textController: passwordController,
                        validationError: authValidationErrors.password,
                        serverError: registerResponse.passwordError,
                        isPass: true,
                        text: "Password"),
                    const SizedBox(
                      height: 4,
                    ),
                    AuthInput(
                        textController: passwordAgainController,
                        validationError: authValidationErrors.password,
                        serverError: registerResponse.passwordError,
                        isPass: true,
                        text: "Password Again"),
                    const SizedBox(
                      height: 24,
                    ),
                    isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              label: "Register",
                              onPressed: registerHandler,
                            ),
                          ),
                    const SizedBox(height: 72),
                    InkWell(
                      onTap: () {
                        widget.changeAuth(
                            AuthScreen.loginForm, emailController.text);
                      },
                      child: RichText(
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.secondary,
                              ),
                            ),
                            TextSpan(
                              text: "Login",
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
        ),
      ),
    );
  }

  registerHandler() async {
    setState(() {
      authValidationErrors = Validator().validateRegister(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          name: nameController.text.trim(),
          surname: surnameController.text.trim(),
          department: _selectedDepartment?.name);
    });

    if (authValidationErrors.valid) {
      setState(() {
        isLoading = true;
      });
      registerResponse = await AuthService.register(
          email: emailController.text.trim(),
          password: passwordController.text,
          name: nameController.text,
          surname: surnameController.text,
          department: _selectedDepartment!.name);

      setState(() {
        isLoading = false;
      });

      if (registerResponse.isValid) {
        widget.changeAuth(
            AuthScreen.registerVerificationForm, emailController.text,
            isRegister: true);
      }
    }
  }
}
