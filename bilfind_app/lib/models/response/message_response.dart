class MessageResponse {
  MessageResponse({
    required this.conversationId,
    required this.content,
    required this.userId,
  });
  late final String conversationId;
  late final String content;
  late final String userId;

  MessageResponse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    content = json['content'];
    conversationId = json['conversationId'];
  }
}
