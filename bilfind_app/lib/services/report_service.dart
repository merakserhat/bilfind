import 'package:bilfind_app/constants/app_constants.dart';
import 'package:bilfind_app/models/report_model.dart';
import 'package:bilfind_app/services/app_client.dart';
import 'package:dio/dio.dart';

class ReportService {
  static Future<List<ReportModel>> getUserReports(
      {String? searchFilter}) async {
    try {
      var response =
          await AppClient().dio.get("${AppConstants.baseUrl}user/reports");
      if (response.statusCode == null) {
        return [];
      }
      if (response.statusCode! >= 400) {
        return [];
      }

      List<ReportModel> reports = (response.data["data"]["reports"] as List)
          .map((e) => ReportModel.fromJson(e))
          .toList();
      return reports;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<bool> reportPost(String postId) async {
    try {
      print("Post is deleting with id: $postId");
      var response = await AppClient()
          .dio
          .post("${AppConstants.baseUrl}post/$postId/report");
      if (response.statusCode == null) {
        return false;
      }
      if (response.statusCode! >= 400) {
        return false;
      }
      print("Successfully reported");
      print(response.data);
      return true;
    } on DioError catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> changeReportStatus(String reportId, String status) async {
    try {
      var response = await AppClient()
          .dio
          .put("${AppConstants.baseUrl}admin/$reportId/$status");
      if (response.statusCode == null) {
        return false;
      }
      if (response.statusCode! >= 400) {
        return false;
      }
      print("Successfully changed status");
      print(response.data);
      return true;
    } on DioError catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<ReportModel>> getReportsList() async {
    try {
      var response =
          await AppClient().dio.get("${AppConstants.baseUrl}admin/report");
      if (response.statusCode == null) {
        return [];
      }
      if (response.statusCode! >= 400) {
        return [];
      }

      List<ReportModel> reportedPosts =
          (response.data["data"]["reports"] as List)
              .map((e) => ReportModel.fromJson(e))
              .toList();
      return reportedPosts;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
