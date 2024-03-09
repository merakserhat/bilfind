import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class PostModel extends Equatable {
  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.images,
    this.price,
    required this.createdAt,
    required this.type,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerDepartment,
    required this.ownerUserId,
    this.favCount = 0,
    this.ownerPhoto,
    this.isMock = false,
    this.mockImages = const [],
  });
  late String id;
  late String userId;
  late String title;
  late int favCount;
  late String content;
  late List<String> images;
  List<Uint8List> mockImages = [];
  late double? price;
  late DateTime createdAt;
  late String type;
  late String ownerName;
  late String ownerEmail;
  late String ownerDepartment;
  late String? ownerPhoto;
  late String ownerUserId;
  late bool isMock;

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
    content = json['content'];
    images = json["images"] != null
        ? List.castFrom<dynamic, String>(json['images'])
        : [];
    price = json["price"];
    favCount = json["favCount"] ?? 0;
    createdAt = DateTime.parse(json['createdAt']).toLocal();
    type = json['type'];
    ownerName = json['ownerName'];
    ownerEmail = json['ownerEmail'];
    ownerDepartment = json['ownerDepartment'];
    ownerUserId = json['ownerUserId'];
    ownerPhoto = json['ownerPhoto'];
    isMock = false;
    mockImages = [];
  }

  @override
  List<Object?> get props => [id];
}
