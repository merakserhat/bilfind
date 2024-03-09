import 'package:bilfind_app/constants/app_constants.dart';
import 'package:bilfind_app/services/app_client.dart';

class AdminService {
  static Future<bool> banUser(String userId) async {
    try {
      var response = await AppClient().dio.put(
            "${AppConstants.baseUrl}admin/$userId/ban",
          );
      if (response.statusCode == null) {
        return false;
      }
      if (response.statusCode! >= 400) {
        return false;
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> changeReportStatus(String reportId, String status) async {
    try {
      var response = await AppClient().dio.put(
            "${AppConstants.baseUrl}admin/$reportId/?${status}",
          );
      if (response.statusCode == null) {
        return false;
      }
      if (response.statusCode! >= 400) {
        return false;
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
