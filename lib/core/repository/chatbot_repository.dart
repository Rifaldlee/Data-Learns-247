import 'package:data_learns_247/features/chatbot/data/models/chat_model.dart';

abstract class ChatbotRepository {
  Future<Chat?> sendChat(String question, String chatBotId);
}