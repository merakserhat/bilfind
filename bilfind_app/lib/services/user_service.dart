import 'package:bilfind_app/constants/app_constants.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/user_model.dart';
import 'package:bilfind_app/screens/create_post/widgets/post_image_creator.dart';
import 'package:bilfind_app/utils/util_functions.dart';
import 'package:dio/dio.dart';

import 'app_client.dart';

class UserService {
  // userRouter.put("/fav", isAuth, putUserFavHandler);

  static Future<bool> changeProfilePhoto(SelectedImage selectedImage) async {
    try {
      FormData formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(selectedImage.imageToUse,
            filename: "${UtilFunctions.generateRandomString()}.png"),
      });

      var response = await AppClient().dio.put(
        "${AppConstants.baseUrl}user/photo",
        data: formData,
        onSendProgress: (int sent, int total) {
          print('Sent: $sent, Total: $total');
        },
      );
      if (response.statusCode == null) {
        return false;
      }
      if (response.statusCode! >= 400) {
        return false;
      }

      Program().userModel = UserModel.fromJson(response.data["data"]["user"]);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> changeFavPost(String postId) async {
    try {
      var response = await AppClient()
          .dio
          .put("${AppConstants.baseUrl}user/fav?postId=$postId");
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

  static Future<bool> changeNotificationSettings(
      bool decision) async {
    try {
      var body = {'subscription': decision};
      var response = await AppClient()
          .dio
          .put("${AppConstants.baseUrl}user/subs", data: body);
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

  static Future<UserModel?> getUserModel(String userId) async {
    try {
      var response = await AppClient()
          .dio
          .get("${AppConstants.baseUrl}user?userId=$userId");
      if (response.statusCode == null) {
        return null;
      }
      if (response.statusCode! >= 400) {
        return null;
      }

      UserModel userModel = UserModel.fromJson(response.data["data"]["user"]);
      return userModel;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> editUser(String fullName, String department) async {
    try {
      var response = await AppClient().dio.put("${AppConstants.baseUrl}user",
          data: {'name': fullName, 'department': department});
      if (response.statusCode == null) {
        return false;
      }
      if (response.statusCode! >= 400) {
        return false;
      }

      Program().userModel = UserModel.fromJson(response.data["data"]["user"]);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
