import 'package:bilfind_app/models/post_model.dart';

class GetUserPostsResponse {
  late final List<PostModel> userPosts;
  late final List<PostModel> favoritePosts;

  GetUserPostsResponse({required this.userPosts, required this.favoritePosts});

  GetUserPostsResponse.fromJson(Map<String, dynamic> json) {
    userPosts =
        (json["userPosts"] as List).map((e) => PostModel.fromJson(e)).toList();

    favoritePosts = (json["favoritePosts"] as List)
        .map((e) => PostModel.fromJson(e))
        .toList();
  }
}
