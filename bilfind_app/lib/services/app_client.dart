import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:bilfind_app/constants/app_constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppClient {
  static final AppClient _instance = AppClient._internal();
  AppClient._internal();

  factory AppClient() {
    return _instance;
  }

  Dio? _dio;
  String? _token;

  set token(String? accessToken) {
    if (accessToken != null && accessToken.isNotEmpty) {
      dio.options.headers["authorization"] = "Bearer $accessToken";
    }
    _token = accessToken;
  }

  String? get token {
    return _token;
  }

  Dio get dio {
    if (_dio == null) {
      initializeDio();
    }
    return _dio!;
  }

  void initializeDio() async {
    _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));
    _dio!.interceptors.add(PrettyDioLogger());
  }
}
