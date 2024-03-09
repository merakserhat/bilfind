import 'package:bilfind_app/models/response/error_response.dart';

class RegisterResponse {
  late bool isValid;
  late ErrorResponse? errorResponse;
  String? passwordError;
  String? emailError;
  String? serverError;
  String? usernameError;
  String? departmentError;
  String? token;

  RegisterResponse({
    this.isValid = true,
    this.passwordError,
    this.emailError,
    this.serverError,
    this.usernameError,
    this.departmentError,
    this.token,
    this.errorResponse,
  });

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    isValid = json["status"] == "success";
    if (json["error"] != null) {
      passwordError = json['error']["password"];
      emailError = json['error']["email"];
      usernameError = json['error']["username"];
      departmentError = json['error']["deparment"];
    }

    token = json["token"];

    // if error is not based on password and email
    if (!isValid &&
        passwordError == null &&
        emailError == null &&
        usernameError == null &&
        departmentError == null) {
      serverError = "Something went wrong";
    }
  }
}
