import 'package:bilfind_app/constants/enums.dart';

class AuthValidationErrors {
  bool valid;
  String? email;
  String? password;
  String? name;
  String? surname;
  String? agreement;
  String? department;

  AuthValidationErrors({
    this.valid = true,
    this.email,
    this.name,
    this.surname,
    this.password,
    this.agreement,
    this.department
  });
}
