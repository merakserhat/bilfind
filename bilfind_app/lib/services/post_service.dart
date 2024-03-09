import 'dart:typed_data';

import 'package:bilfind_app/constants/error_codes.dart';
import 'package:bilfind_app/models/post_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/request/create_post_request.dart';
import 'package:bilfind_app/models/request/edit_post_request.dart';
import 'package:bilfind_app/models/response/error_response.dart';
import 'package:bilfind_app/models/response/get_post_detail_response.dart';
import 'package:bilfind_app/models/response/get_user_posts_response.dart';
import 'package:bilfind_app/models/response/login_response.dart';
import 'package:bilfind_app/utils/util_functions.dart';
import 'package:dio/dio.dart';
import 'package:bilfind_app/constants/app_constants.dart';
import 'package:bilfind_app/services/app_client.dart';

class PostService {
  static Future<GetUserPostsResponse?> getUserPosts(String userId) async {
    try {
      String filter = "";

      if (Program().userModel?.id != userId) {
        filter = "?userId=${userId}";
      }
      var response =
          await AppClient().dio.get("${AppConstants.baseUrl}post/user$filter");
      if (response.statusCode == null) {
        return null;
      }
      if (response.statusCode! >= 400) {
        return null;
      }

      GetUserPostsResponse getUserPostsResponse =
          GetUserPostsResponse.fromJson(response.data["data"]);
      return getUserPostsResponse;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<PostModel>> getPostList({String? searchFilter}) async {
    try {
      print("searchFilter");
      print(searchFilter);
      var response = await AppClient().dio.get(
          "${AppConstants.baseUrl}post/list?${searchFilter != null && searchFilter.isNotEmpty ? searchFilter : ""}");
      if (response.statusCode == null) {
        return [];
      }
      if (response.statusCode! >= 400) {
        return [];
      }

      List<PostModel> posts = (response.data["data"]["posts"] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return posts;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<PostModel?> createPost(
      CreatePostRequest createPostRequest) async {
    try {
      FormData formData = FormData.fromMap({
        'title': createPostRequest.title,
        'content': createPostRequest.content,
        'type': createPostRequest.postType,
      });

      if (createPostRequest.price != null) {
        formData.fields
            .add(MapEntry("price", createPostRequest.price!.toString()));
      }

      for (Uint8List bytes in createPostRequest.images) {
        var file = MultipartFile.fromBytes(bytes,
            filename: UtilFunctions.generateRandomString() + ".png");
        formData.files.add(MapEntry("image", file));
      }

      var response = await AppClient().dio.post(
        "${AppConstants.baseUrl}post",
        data: formData,
        onSendProgress: (int sent, int total) {
          print('Sent: $sent, Total: $total');
        },
      );
      if (response.statusCode == null) {
        return null;
      }
      if (response.statusCode! >= 400) {
        return null;
      }

      return PostModel.fromJson(response.data["data"]["post"]);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<PostModel?> editPost(EditPostRequest editPostRequest) async {
    try {
      FormData formData = FormData.fromMap({
        'title': editPostRequest.title,
        'content': editPostRequest.content,
        'postId': editPostRequest.postId,
      });

      if (editPostRequest.price != null) {
        formData.fields
            .add(MapEntry("price", editPostRequest.price!.toString()));
      }

      for (Uint8List bytes in editPostRequest.images) {
        var file = MultipartFile.fromBytes(bytes,
            filename: "${UtilFunctions.generateRandomString()}.png");
        formData.files.add(MapEntry("image", file));
      }

      for (String images in editPostRequest.previousImages) {
        formData.fields.add(MapEntry("images", images));
      }

      var response = await AppClient().dio.put(
        "${AppConstants.baseUrl}post",
        data: formData,
        onSendProgress: (int sent, int total) {
          print('Sent: $sent, Total: $total');
        },
      );
      if (response.statusCode == null) {
        return null;
      }
      if (response.statusCode! >= 400) {
        return null;
      }

      return PostModel.fromJson(response.data["data"]["post"]);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<GetPostDetailResponse?> getPostDetail(String postId) async {
    try {
      var response = await AppClient()
          .dio
          .get("${AppConstants.baseUrl}post?postId=${postId}");
      if (response.statusCode == null) {
        return null;
      }
      if (response.statusCode! >= 400) {
        return null;
      }

      GetPostDetailResponse getPostDetailResponse =
          GetPostDetailResponse.fromJson(response.data["data"]);
      return getPostDetailResponse;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> createComment(
      String postId, String content, String? parentId) async {
    try {
      var body = {'postId': postId, 'content': content};
      if (parentId != null) {
        body["parentId"] = parentId;
      }
      var response = await AppClient()
          .dio
          .post("${AppConstants.baseUrl}post/comment", data: body);
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

  static Future<bool> deletePost(String postId) async {
    try {
      print("Post is deleting with id: $postId");
      var response = await AppClient()
          .dio
          .delete("${AppConstants.baseUrl}post?postId=$postId");
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
}
