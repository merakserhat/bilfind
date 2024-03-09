import 'package:bilfind_app/constants/app_constants.dart';
import 'package:bilfind_app/models/message_model.dart';
import 'package:bilfind_app/models/post_model.dart';

import 'program.dart';

class ConversationModel {
  ConversationModel({
    required this.id,
    required this.post,
    required this.ownerPhoto,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerId,
    required this.ownerDepartment,
    required this.senderPhoto,
    required this.senderName,
    required this.senderEmail,
    required this.senderId,
    required this.senderDepartment,
    required this.createdAt,
    required this.status,
    required this.messages,
  });
  late final String id;
  late final PostModel post;
  late final String? ownerPhoto;
  late final String ownerName;
  late final String ownerEmail;
  late final String ownerId;
  late final String ownerDepartment;
  late final String? senderPhoto;
  late final String senderName;
  late final String senderEmail;
  late final String senderId;
  late final String senderDepartment;
  late final DateTime createdAt;
  late final String status;
  late final List<MessageModel> messages;

  ConversationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    post = PostModel.fromJson(json['post']);
    ownerPhoto = json['ownerPhoto'];
    ownerName = json['ownerName'];
    ownerEmail = json['ownerEmail'];
    ownerId = json['ownerId'];
    ownerDepartment = json['ownerDepartment'];
    senderPhoto = json['senderPhoto'];
    senderName = json['senderName'];
    senderEmail = json['senderEmail'];
    senderId = json['senderId'];
    senderDepartment = json['senderDepartment'];
    createdAt = DateTime.parse(json['createdAt']).toLocal();
    status = json['status'];
    messages = (json['messages'] as List)
        .map((e) => MessageModel.fromJson(e))
        .toList();
  }

  String getChatImageUrl() {
    String? imageUrl;

    if (senderId == Program().userModel?.id) {
      imageUrl = ownerPhoto;
    } else {
      imageUrl = senderPhoto;
    }

    imageUrl ??= AppConstants.defaultProfilePhoto;

    return imageUrl;
  }

  String getChatUserName() {
    if (senderId == Program().userModel?.id) {
      return ownerName;
    }

    return senderName;
  }
}
