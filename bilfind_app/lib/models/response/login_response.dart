class LoginResponse {
  late bool isValid;
  String? passwordError;
  String? emailError;
  String? serverError;
  String? token;

  LoginResponse({
    this.isValid = true,
    this.passwordError,
    this.emailError,
    this.serverError,
    this.token,
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    isValid = json["status"] == "success";
    if (json["error"] != null) {
      passwordError = json['error']["password"];
      emailError = json['error']["email"];
    }

    token = json["token"];

    // if error is not based on password and email
    if (!isValid && passwordError == null && emailError == null) {
      serverError = "Something went wrong";
    }
  }
}
