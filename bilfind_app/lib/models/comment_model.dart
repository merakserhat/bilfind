class CommentModel {
  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    this.parentId,
    required this.content,
    required this.createdAt,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerDepartment,
  });
  late final String id;
  late final String postId;
  late final String userId;
  late final String? parentId;
  late final String? ownerPhoto;
  late final String content;
  late final DateTime createdAt;
  late final String ownerName;
  late final String ownerEmail;
  late final String ownerDepartment;

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    userId = json['userId'];
    parentId = json['parentId'];
    ownerPhoto = json['ownerPhoto'];
    content = json['content'];
    createdAt = DateTime.parse(json['createdAt']).toLocal();
    ownerName = json['ownerName'];
    ownerEmail = json['ownerEmail'];
    ownerDepartment = json['ownerDepartment'];
  }
}
