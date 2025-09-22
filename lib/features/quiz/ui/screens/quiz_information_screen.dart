import 'package:data_learns_247/core/utils/error_dialog.dart';
import 'package:data_learns_247/features/quiz/ui/widget/placeholder/quiz_information_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/theme/theme.dart';
import 'package:data_learns_247/features/quiz/cubit/quiz_information_cubit.dart';
import 'package:data_learns_247/features/quiz/cubit/start_quiz_cubit.dart';
import 'package:data_learns_247/features/quiz/data/models/list_attempts_model.dart';
import 'package:data_learns_247/features/quiz/data/models/quiz_information_model.dart';
import 'package:data_learns_247/shared_ui/widgets/affirmation_dialog.dart';
import 'package:data_learns_247/shared_ui/widgets/gradient_button.dart';

class QuizInformationScreen extends StatefulWidget {
  final String quizId;
  final String lessonId;
  final String courseId;
  final String? chatbotId;

  const QuizInformationScreen({
    super.key,
    required this.quizId,
    required this.lessonId,
    required this.courseId,
    this.chatbotId
  });

  @override
  State<QuizInformationScreen> createState() => _QuizInformationState();
}

class _QuizInformationState extends State<QuizInformationScreen> {

  ListAttempts? selectedAttempt;

  @override
  void initState() {
    super.initState();
    context.read<QuizInformationCubit>().fetchQuizInformation(widget.quizId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizInformationCubit, QuizInformationState>(
      builder: (context, state) {
        if (state is QuizInformationLoading) {
          return const QuizInformationPlaceholder();
        }
        if (state is QuizInformationCompleted) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                context.pushNamed(
                  RouteConstants.listLessons,
                  queryParameters: {
                    'courseId': widget.courseId.toString(),
                  }
                );
              }
            },
            child: Scaffold(
              backgroundColor: kWhiteColor,
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          quizInformation(state.quizInformation),
                          const SizedBox(height: 8),
                          if (state.quizInformation.listAttempt!.isNotEmpty)
                            listAttempts(state.quizInformation.listAttempt!),
                        ],
                      ),
                    ),
                    startQuizButton(
                      state.quizInformation.totalAttempts,
                      state.quizInformation.allowedAttempts!,
                    ),
                  ],
                ),
              )
            ),
          );
        }
        if (state is QuizInformationError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ErrorDialog.showErrorDialog(context, state.message, () {
              Navigator.of(context).pop();
              context.read<QuizInformationCubit>().fetchQuizInformation(widget.quizId);
            });
          });
        }
        return const SizedBox.shrink();
      }
    );
  }

  Widget quizInformation(QuizInformation quizInformation) {

    final int remainingAttempts = quizInformation.allowedAttempts! - quizInformation.totalAttempts!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Tentang ${quizInformation.title}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: kBlackColor,
              fontSize: 18
            )
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                quizInformationItem(
                  'Nilai minimum',
                  ' : ${quizInformation.passingPercent.toString()} persen'
                ),
                const SizedBox(height: 6),
                quizInformationItem(
                  'Batas percobaan',
                  ' : ${quizInformation.allowedAttempts.toString()} kali'
                ),
                const SizedBox(height: 6),
                quizInformationItem(
                  'Jumlah soal',
                  ' : ${quizInformation.totalQuestions.toString()} soal'
                ),
                const SizedBox(height: 6),
                quizInformationItem(
                  'Batas waktu',
                  ' : ${quizInformation.timeLimit.toString()} menit'
                ),
                const SizedBox(height: 6),
                quizInformationItem(
                  'Sisa kesempatan',
                  ' : ${remainingAttempts.toString()} kali'
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget quizInformationItem(String title, String content) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: bold
            )
          )
        ),
        Expanded(
          flex: 6,
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge
          )
        )
      ],
    );
  }

  Widget listAttempts(List<ListAttempts> attempts) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<ListAttempts>(
        isExpanded: true,
        value: selectedAttempt,
        hint: Text(
          'Percobaan yang dilakukan',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: bold
          ),
        ),
        items: attempts.map((attempt) {
          return DropdownMenuItem<ListAttempts>(
            value: attempt,
            child: Text('Percobaan ${attempt.attempt}'),
            onTap: () {
              context.pushNamed(
                RouteConstants.attemptDetail,
                queryParameters: {
                  'attemptId': attempt.id.toString(),
                  'lessonId': widget.lessonId.toString(),
                  'courseId': widget.courseId.toString(),
                  'chatbotId': widget.chatbotId.toString()
                }
              );
            },
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedAttempt = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.withOpacity(0.2)
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 184,
          decoration: const BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(kGreenColor),
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 30,
        ),
      ),
    );
  }

  Widget startQuizButton(int? totalAttempts, int allowedAttempts) {
    final bool hasReachedLimit = totalAttempts != null && totalAttempts >= allowedAttempts;
    return BlocConsumer<StartQuizCubit, StartQuizState>(
      builder: (context, state) {
        if(state is StartQuizLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: kGreenColor,
              backgroundColor: kWhiteColor,
            ),
          );
        }
        return GradientButton(
          buttonTitle: hasReachedLimit
              ? 'Sudah tidak dapat melakukan kuis lagi'
              : 'Mulai kuis',
          onPressed: hasReachedLimit ? () {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.fillColored,
              direction: TextDirection.ltr,
              alignment: Alignment.bottomCenter,
              closeButtonShowType: CloseButtonShowType.always,
              showIcon: true,
              dragToClose: true,
              autoCloseDuration: const Duration(seconds: 5),
              icon: const Icon(Icons.cancel_outlined),
              title: const Text('Tidak dapat memulai kuis'),
              description: RichText(
                text: const TextSpan(
                  text: 'Anda sudah berada pada batas maksimal untuk mengambil kuis'
                )
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16
              ),
              borderRadius: BorderRadius.circular(12),
            );
          } : () {
            showDialog(
              context: context,
              builder: (context) => AffirmationDialog(
                message: 'Apakah anda yakin ingin memulai kuis sekarang?',
                onProceed: () {
                  Navigator.of(context).pop();
                  context.pushNamed(
                    RouteConstants.quizScreen,
                    queryParameters: {
                      'lessonId': widget.lessonId.toString(),
                      'courseId': widget.courseId.toString(),
                      'chatbotId': widget.chatbotId.toString()
                    }
                  );
                  context.read<StartQuizCubit>().startQuiz(widget.quizId);
                }
              )
            );
          },
        );
      },
      listener: (context, state) {
        if (state is StartQuizCompleted) {
          context.pushNamed(
            RouteConstants.quizScreen,
              queryParameters: {
                'lessonId': widget.lessonId.toString(),
                'courseId': widget.courseId.toString(),
                'chatbotId': widget.chatbotId.toString()
              }
          );
        }
        else if (state is StartQuizError) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
            direction: TextDirection.ltr,
            alignment: Alignment.bottomCenter,
            closeButtonShowType: CloseButtonShowType.always,
            showIcon: true,
            dragToClose: true,
            autoCloseDuration: const Duration(seconds: 5),
            title: const Text('Gagal memulai kuis'),
            description: RichText(text: TextSpan(text: state.message)),
            icon: const Icon(Icons.cancel_outlined),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16
            ),
            borderRadius: BorderRadius.circular(12),
          );
        }
      }
    );
  }
}