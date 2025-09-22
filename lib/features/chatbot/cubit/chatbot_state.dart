part of 'chatbot_cubit.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotCompleted extends ChatbotState {
  final Chat? chat;

  const ChatbotCompleted(this.chat);

  @override
  List<Object?> get props => [chat];
}

class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError(this.message);

  @override
  List<Object> get props => [message];
}

class ChatbotSaved extends ChatbotState {
  final List<Chat> chats;

  const ChatbotSaved(this.chats);

  @override
  List<Object?> get props => [chats];
}