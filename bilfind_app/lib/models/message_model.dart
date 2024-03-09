class MessageModel {
  MessageModel({
    required this.conversationId,
    required this.senderId,
    required this.createdAt,
    required this.text,
    required this.messageType,
  });
  late final String conversationId;
  late final String senderId;
  late final DateTime createdAt;
  late final String text;
  late final String messageType;

  MessageModel.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversationId'];
    senderId = json['senderId'];
    createdAt = DateTime.parse(json['createdAt']).toLocal();
    text = json['text'];
    messageType = json['messageType'];
  }
}
