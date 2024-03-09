import 'package:bilfind_app/constants/app_constants.dart';
import 'package:bilfind_app/models/conversation_model.dart';
import 'package:bilfind_app/services/app_client.dart';

class ChatService {
  static Future<ConversationModel?> createConversation(String postId) async {
    try {
      var body = {'postId': postId};
      var response =
          await AppClient().dio.post("${AppConstants.baseUrl}chat", data: body);
      if (response.statusCode == null) {
        return null;
      }
      if (response.statusCode! >= 400) {
        return null;
      }

      return ConversationModel.fromJson(response.data["data"]["conversation"]);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<ConversationModel>> getConversations() async {
    try {
      var response = await AppClient()
          .dio
          .get("${AppConstants.baseUrl}chat/conversations");
      if (response.statusCode == null) {
        return [];
      }
      if (response.statusCode! >= 400) {
        return [];
      }

      List<ConversationModel> conversations =
          (response.data["data"]["conversations"] as List)
              .map((e) => ConversationModel.fromJson(e))
              .toList();
      return conversations;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
