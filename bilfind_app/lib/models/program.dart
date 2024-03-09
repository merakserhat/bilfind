import 'package:bilfind_app/models/user_model.dart';
import 'package:bilfind_app/services/app_client.dart';
import 'package:bilfind_app/services/auth_service.dart';
import 'package:bilfind_app/services/local_service.dart';
import 'package:flutter/cupertino.dart';

class Program extends ChangeNotifier {
  static final Program _instance = Program._internal();

  factory Program() {
    return _instance;
  }

  Program._internal() {}

  String? email;
  String? _token;

  String? get token => _token;

  set token(String? token) {
    _token = token;
    if (token == null) {
      LocalService().deleteToken();
    } else {
      LocalService().setToken(token);
    }

    AppClient().token = token;
  }

  Future<bool> retrieveUser() async {
    String? token = await LocalService().getToken();
    Program().token = token;
    if (Program().userModel != null) {
      return true;
    } else {
      bool validated = await AuthService.validateToken();
      return validated;
    }
  }

  UserModel? userModel;
}
