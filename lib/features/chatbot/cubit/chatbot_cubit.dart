import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/chatbot_repository.dart';
import 'package:data_learns_247/core/repository/implementation/chatbot_repository_impl.dart';
import 'package:data_learns_247/core/utils/chat_database_helper.dart';
import 'package:data_learns_247/core/utils/shared_pref_util.dart';
import 'package:data_learns_247/features/chatbot/data/models/chat_model.dart';
import 'package:data_learns_247/features/chatbot/domains/use_cases/chatbot_use_case.dart';
import 'package:equatable/equatable.dart';

part 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final ChatbotRepository _chatbotRepository = ChatBotRepositoryImpl();
  final List<Chat> _savedChats = [];
  final ChatDatabaseHelper _chatDatabaseHelper = ChatDatabaseHelper();

  List<Chat> get savedChats => List.unmodifiable(_savedChats);

  final String courseId;

  ChatbotCubit({required this.courseId}) : super(ChatbotInitial());

  void sendChat(String question, String chatBotId) async {
    try {
      emit(ChatbotLoading());

      Chat? response = await SendChat(question, chatBotId, _chatbotRepository).call();
      if (response != null) {
        emit(ChatbotCompleted(response));
      } else {
        emit(const ChatbotError('Cannot answer the question'));
      }
    } catch (e) {
      emit(ChatbotError(e.toString()));
    }
  }

  void saveChat(Chat chat) async {
    try {
      final enrichedChat = Chat(
        text: chat.text,
        question: chat.question,
        chatId: chat.chatId,
        chatMessageId: chat.chatMessageId,
        isStreamValid: chat.isStreamValid,
        sessionId: chat.sessionId,
        memoryType: chat.memoryType,
        userId: SharedPrefUtil.getUserId(),
        courseId: courseId,
      );

      _savedChats.add(enrichedChat);
      await _chatDatabaseHelper.insertChat(enrichedChat);
      emit(ChatbotSaved(List.from(_savedChats)));
    } catch (e) {
      emit(ChatbotError(e.toString()));
    }
  }

  void loadSavedChats() async {
    try {
      final userId = SharedPrefUtil.getUserId();
      final chats = await _chatDatabaseHelper.getChatsByUserAndCourse(userId, courseId);
      _savedChats.clear();
      _savedChats.addAll(chats);
      emit(ChatbotSaved(List.from(_savedChats)));
    } catch (e) {
      emit(ChatbotError('Failed to load chats: $e'));
    }
  }
}