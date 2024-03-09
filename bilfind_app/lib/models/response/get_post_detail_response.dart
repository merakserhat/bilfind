import 'package:bilfind_app/models/comment_model.dart';
import 'package:bilfind_app/models/post_model.dart';

class GetPostDetailResponse {
  late final PostModel postModel;
  late final List<CommentModel> comments;

  GetPostDetailResponse({required this.postModel, required this.comments});

  GetPostDetailResponse.fromJson(Map<String, dynamic> json) {
    postModel = PostModel.fromJson(json["post"]);
    comments = (json["comments"] as List)
        .map((e) => CommentModel.fromJson(e))
        .toList();
  }
}
