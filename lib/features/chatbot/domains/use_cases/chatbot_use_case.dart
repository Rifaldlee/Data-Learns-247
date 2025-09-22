import 'package:data_learns_247/core/repository/chatbot_repository.dart';
import 'package:data_learns_247/features/chatbot/data/models/chat_model.dart';

class SendChat {
  final String _question;
  final String _chatbotId;
  final ChatbotRepository _chatbotRepository;

  SendChat(this._question, this._chatbotId, this._chatbotRepository);

  Future<Chat?> call() async {
    return await _chatbotRepository.sendChat(_question, _chatbotId);
  }
}