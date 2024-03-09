class ErrorResponse {
  ErrorResponse({
    required this.status,
    required this.errors,
  });
  late final String status;
  late final List<Errors> errors;

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errors = List.from(json['errors']).map((e) => Errors.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['errors'] = errors.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Errors {
  Errors({
    required this.errorCode,
    required this.message,
  });
  late final String errorCode;
  late final String message;

  Errors.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['errorCode'] = errorCode;
    _data['message'] = message;
    return _data;
  }
}
