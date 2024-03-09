import 'package:bilfind_app/constants/error_codes.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/response/error_response.dart';
import 'package:bilfind_app/models/response/login_response.dart';
import 'package:bilfind_app/models/response/register_response.dart';
import 'package:bilfind_app/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:bilfind_app/constants/app_constants.dart';
import 'package:bilfind_app/services/app_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<LoginResponse> login(
      {required String email, required String password}) async {
    LoginResponse loginResponse = LoginResponse();
    try {
      var response = await AppClient().dio.post(
          "${AppConstants.baseUrl}auth/login",
          data: {'email': email, 'password': password});
      if (response.statusCode == null) {
        loginResponse.serverError = AppConstants.serverErrorMessage;
        loginResponse.isValid = false;
        return loginResponse;
      }
      if (response.statusCode! >= 400) {
        loginResponse.serverError = AppConstants.serverErrorMessage;
        loginResponse.isValid = false;
        return loginResponse;
      }
      print("Successfully logged in");
      print(response.data);
      String token = response.data["data"]["token"];
      String userEmail = response.data["data"]["user"]["email"];
      UserModel user = UserModel.fromJson(response.data["data"]["user"]);
      Program().token = token;
      Program().email = userEmail;
      Program().userModel = user;
      loginResponse.token = token;
      return loginResponse;
    } on DioError catch (e) {
      if (e.response?.data != null) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(e.response!.data);
        String? emailError;
        String? passwordError;
        for (Errors errors in errorResponse.errors) {
          if (errors.errorCode == ErrorCodes.EMAIL_DOES_NOT_EXISTS.name) {
            emailError = errors.message;
          }
          if (errors.errorCode == ErrorCodes.WRONG_PASSWORD.name) {
            passwordError = errors.message;
          }
          if (errors.errorCode == ErrorCodes.BANNED.name) {
            emailError = errors.message;
          }
        }
        return LoginResponse(
          isValid: false,
          emailError: emailError,
          passwordError: passwordError,
        );
      }
      return LoginResponse(
        isValid: false,
        serverError: AppConstants.serverErrorMessage,
      );
    } catch (e) {
      print(e.toString());
      return LoginResponse(
        isValid: false,
        serverError: AppConstants.serverErrorMessage,
      );
    }
  }

  static Future<RegisterResponse> register({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String department,
  }) async {
    RegisterResponse registerResponse = RegisterResponse();
    try {
      var response = await AppClient()
          .dio
          .post("${AppConstants.baseUrl}auth/register", data: {
        'email': email,
        'password': password,
        'name': name,
        'familyName': surname,
        'department': department
      });
      if (response.statusCode == null) {
        registerResponse.serverError = AppConstants.serverErrorMessage;
        registerResponse.isValid = false;
        return registerResponse;
      }
      if (response.statusCode! >= 400) {
        registerResponse.serverError = AppConstants.serverErrorMessage;
        registerResponse.isValid = false;
        return registerResponse;
      }
      print("Successfully registered");
      print(response.data);

      return registerResponse;
    } on DioError catch (e) {
      if (e.response?.data != null) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(e.response!.data);
        String? emailError;
        for (Errors errors in errorResponse.errors) {
          if (errors.errorCode == ErrorCodes.EMAIL_ALREADY_EXISTS.name) {
            emailError = errors.message;
          } else if (errors.errorCode == ErrorCodes.BANNED) {
            emailError = errors.message;
          }
        }
        return RegisterResponse(isValid: false, emailError: emailError);
      }
      return RegisterResponse(
        isValid: false,
        serverError: AppConstants.serverErrorMessage,
      );
    } catch (e) {
      print(e.toString());
      return RegisterResponse(
        isValid: false,
        serverError: AppConstants.serverErrorMessage,
      );
    }
  }

  static Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      var response = await AppClient().dio.put(
          "${AppConstants.baseUrl}auth/password",
          data: {'oldPassword': oldPassword, 'newPassword': newPassword});
      if (response.statusCode == null) {
        return false;
      }
      if (response.statusCode! >= 400) {
        return false;
      }

      print("Password successfully updated");
      print(response.data);
      String token = response.data["data"]["token"];
      Program().token = token;
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> verifyRegistrationCode({
    required String email,
    required String code,
  }) async {
    try {
      var response = await AppClient()
          .dio
          .put("${AppConstants.baseUrl}auth/register/otp", data: {
        'email': email,
        'otp': int.parse(code),
      });
      if (response.statusCode == null) {
        return false;
      }
      if (response.statusCode! >= 400) {
        return false;
      }
      print("Successfully registered");
      print(response.data);

      String token = response.data["data"]["token"];
      String userEmail = response.data["data"]["user"]["email"];
      UserModel user = UserModel.fromJson(response.data["data"]["user"]);
      Program().token = token;
      Program().email = userEmail;
      Program().userModel = user;

      return true;
    } on DioError catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteUser() async {
    try {
      print("Account is deleting for email: ${Program().email}");
      var response = await AppClient().dio.delete(
          "${AppConstants.baseUrl}auth/user?email=${Program().userModel!.email}");
      if (response.statusCode == null) {
        return false;
      }
      if (response.statusCode! >= 400) {
        return false;
      }
      print("Successfully deleted");
      print(response.data);
      return true;
    } on DioError catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> validateToken() async {
    try {
      var response =
          await AppClient().dio.get("${AppConstants.baseUrl}auth/validate");
      if (response.statusCode == null) {
        return false;
      }
      if (response.statusCode! >= 400) {
        return false;
      }
      print("Successfully validated token");
      UserModel user = UserModel.fromJson(response.data["data"]["user"]);
      Program().userModel = user;
      print(response.data);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> getResetPasswordOtp({required String email}) async {
    try {
      var response = await AppClient()
          .dio
          .get("${AppConstants.baseUrl}auth/password/reset?email=${email}");
      if (response.statusCode == null) {
        return false;
      }
      if (response.statusCode! >= 400) {
        return false;
      }
      print("Successfully got orp code");

      return true;
    } on DioError catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> verifyResetPasswordCode({
    required String email,
    required String code,
  }) async {
    try {
      var response = await AppClient()
          .dio
          .put("${AppConstants.baseUrl}auth/password/otp", data: {
        'email': email,
        'otp': int.parse(code),
      });
      if (response.statusCode == null) {
        return null;
      }
      if (response.statusCode! >= 400) {
        return null;
      }
      String token = response.data["data"]["resetToken"];

      return token;
    } on DioError catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> resetPassword({
    required String newPassword,
    required String resetToken,
  }) async {
    try {
      var response = await AppClient().dio.put(
          "${AppConstants.baseUrl}auth/password/reset",
          data: {'resetToken': resetToken, 'newPassword': newPassword});
      if (response.statusCode == null) {
        return false;
      }
      if (response.statusCode! >= 400) {
        return false;
      }

      print("Password successfully updated");
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
