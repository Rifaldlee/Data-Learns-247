import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_learns_247/features/chatbot/cubit/chatbot_cubit.dart';
import 'package:data_learns_247/features/chatbot/ui/screens/chatbot_view.dart';

class ChatbotScreen extends StatelessWidget {
  final String chatbotId;
  final String courseId;

  const ChatbotScreen({
    super.key,
    required this.chatbotId,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatbotCubit(courseId: courseId),
      child: ChatbotView(chatbotId: chatbotId),
    );
  }
}