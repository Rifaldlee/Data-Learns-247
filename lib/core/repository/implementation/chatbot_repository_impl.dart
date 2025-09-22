import 'package:data_learns_247/core/provider/api.dart';
import 'package:data_learns_247/core/provider/network_helper.dart';
import 'package:data_learns_247/core/provider/network_service.dart';
import 'package:data_learns_247/core/repository/chatbot_repository.dart';
import 'package:data_learns_247/features/chatbot/data/models/chat_model.dart';

class ChatBotRepositoryImpl extends ChatbotRepository {

  @override
  Future<Chat?> sendChat(String question, String chatBotId) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.post,
        baseUrl: API.chatbotBaseUrl,
        endpoint: chatBotId,
        useBearer: true,
        body: {'question': question}
      );

      return NetworkHelper.filterResponse(
        callBack: (json) => Chat.fromJson(json),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }
}