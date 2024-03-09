import 'package:bilfind_app/models/post_model.dart';

class ReportModel {
  ReportModel(
      {required this.id,
      required this.userId,
      required this.postId,
      this.content,
      required this.createdAt,
      required this.status,
      required this.postModel});
  late final String id;
  late String userId;
  late String postId;
  late String? content;
  late final DateTime createdAt;
  late String status;
  late final PostModel postModel;

  ReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    postId = json['postId'];
    content = json['content'];
    createdAt = DateTime.parse(json['createdAt']);
    status = json['status'];
    postModel = PostModel.fromJson(json["post"]);
  }
}
