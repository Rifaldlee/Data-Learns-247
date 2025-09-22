import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/chatbot/cubit/chatbot_cubit.dart';
import 'package:data_learns_247/features/chatbot/data/models/chat_model.dart';
import 'package:data_learns_247/features/chatbot/ui/screens/chatbot_screen.dart';

class ChatbotView extends StatefulWidget {
  final String chatbotId;

  const ChatbotView({super.key, required this.chatbotId});

  @override
  State<ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<ChatbotView> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatbotCubit>().loadSavedChats();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatbotCubit, ChatbotState>(
      builder: (context, state) {

        final chatbotCubit = context.read<ChatbotCubit>();
        final savedChats = chatbotCubit.savedChats;
        final isLoading = state is ChatbotLoading;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: chatBubble(savedChats, isLoading),
              ),
            ),
            sendBar(),
          ],
        );
      },
    );
  }

  Widget chatBubble(List<Chat> chats, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...chats.map((chat) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (chat.question != null && chat.question!.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      decoration: BoxDecoration(
                        color: kGreenColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        chat.question!,
                        style: const TextStyle(fontSize: 16),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              if (chat.text != null && chat.text!.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        chat.text!,
                        style: const TextStyle(fontSize: 16),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
            ],
          );
        }),

        if (isLoading)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: kGreenColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text("Menjawab pertanyaan..."),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget sendBar() {
    return BlocConsumer<ChatbotCubit, ChatbotState>(
      listener: (context, state) {
        if (state is ChatbotCompleted && state.chat != null) {
          context.read<ChatbotCubit>().saveChat(state.chat!);
        }
      },
      builder: (context, state) {
        final isLoading = state is ChatbotLoading;
        return Container(
          margin: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  cursorColor: kGreenColor,
                  enabled: !isLoading,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: isLoading ? "Answering question..." : "Ask Chatbot",
                    border: InputBorder.none,
                    isCollapsed: true,
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.all(12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, child) {
                  final questionText = value.text.trim();
                  final isSendable = questionText.isNotEmpty && !isLoading;

                  return IconButton(
                    onPressed: isSendable ? () {
                      final chatbotCubit = context.read<ChatbotCubit>();
                      final chatbotId = (context.findAncestorWidgetOfExactType<ChatbotScreen>()!).chatbotId;
                      chatbotCubit.sendChat(questionText, chatbotId);
                      controller.clear();
                    } : null,
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(EdgeInsets.all(14)),
                      backgroundColor: WidgetStatePropertyAll(
                        isSendable ? kGreenColor : kGreenColor.withOpacity(0.5),
                      ),
                    ),
                    icon: const Icon(
                      Icons.send,
                      color: kWhiteColor,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}