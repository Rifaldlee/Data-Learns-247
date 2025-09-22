import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/theme.dart';
import 'package:data_learns_247/core/utils/error_dialog.dart';
import 'package:data_learns_247/features/quiz/data/models/attempt_model.dart';
import 'package:data_learns_247/features/quiz/data/models/list_questions_model.dart';
import 'package:data_learns_247/features/quiz/ui/widget/placeholder/attempt_detail_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/quiz/cubit/attempt_detail_cubit.dart';
import 'package:data_learns_247/shared_ui/widgets/custom_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AttemptDetailScreen extends StatefulWidget{
  final String attemptId;
  final String lessonId;
  final String courseId;
  final String? chatbotId;

  const AttemptDetailScreen({
    super.key,
    required this.attemptId,
    required this.lessonId,
    required this.courseId,
    this.chatbotId
  });

  @override
  State<AttemptDetailScreen> createState() => _AttemptDetailState();
}

class _AttemptDetailState extends State<AttemptDetailScreen> {

  @override
  void initState() {
    context.read<AttemptDetailCubit>().fetchAttemptDetail(widget.attemptId);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttemptDetailCubit, AttemptDetailState>(
      builder: (context, state) {
        if (state is AttemptDetailLoading) {
          return const AttemptDetailPlaceholder();
        }
        if (state is AttemptDetailCompleted) {
          Color statusColor = kLightGreyColor;
          if (state.attempt.status == "pass") {
            statusColor = kGreenColor;
          } else {
            statusColor = kRedColor;
          }
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: kWhiteColor,
              statusBarIconBrightness: Brightness.dark
            ),
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) {
                  context.pushNamed(
                    RouteConstants.lessonScreen,
                    queryParameters: {
                      'lessonId': widget.lessonId.toString(),
                      'courseId': widget.courseId.toString(),
                      'chatbotId': widget.chatbotId.toString()
                    }
                  );
                }
              },
              child: Scaffold(
                appBar: CustomAppBar(
                  showBackButton: true,
                  backAction: () {
                    context.pushNamed(
                      RouteConstants.lessonScreen,
                      queryParameters: {
                        'lessonId': widget.lessonId.toString(),
                        'courseId': widget.courseId.toString(),
                        'chatbotId': widget.chatbotId.toString()
                      }
                    );
                  },
                ),
                backgroundColor: kWhiteColor,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal : 32,
                      vertical: 16
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: 72,
                          lineWidth: 12,
                          percent: state.attempt.grade.toDouble() / 100,
                          progressColor: statusColor,
                          center: Text( state.attempt.grade == null ? '0' : state.attempt.grade.toString(),
                            style: Theme.of(context).textTheme.headlineLarge
                          ),
                        ),
                        const SizedBox(height: 16),
                        attemptInformation(state.attempt),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Jawaban anda',
                                style: Theme.of(context).textTheme.headlineSmall
                              )
                            )
                          ],
                        ),
                        listQuestion(state.attempt.listQuestions!),
                      ],
                    ),
                  ),
                )
              ),
            ),
          );
        }
        if (state is AttemptDetailError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ErrorDialog.showErrorDialog(context, state.message, () {
              Navigator.of(context).pop();
              context.read<AttemptDetailCubit>().fetchAttemptDetail(widget.attemptId);
            });
          });
        }
        return const Text("data");
      },
    );
  }

  Widget attemptInformation(Attempt attempt) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            attemptInformationItem(
              'Percobaan ke',
              ' : ${attempt.attemptCount.toString()}'
            ),
            attemptInformationItem(
              'Waktu penyelesaian',
              ' : ${attempt.startDate}'
            ),
            attemptInformationItem(
              'Total waktu',
              ' : ${attempt.duration?.replaceAll('-', '') ?? ''}'
            ),
          ],
        ),
      ),
    );
  }

  Widget attemptInformationItem(String title, String content) {
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

  Widget listQuestion(List<ListQuestions> listQuestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: listQuestions.asMap().entries.map((entry) {
        final listQuestion = entry.value;
        final answer = listQuestion.answer;
        final answerChoice = answer?.choice;

        final isAnswerEmpty = answer == null || (answerChoice == null || answerChoice == "");

        final backgroundColor = isAnswerEmpty ? kLightGreyColor.withOpacity(0.2)
          : (answer.isCorrect! ? kGreenColor.withOpacity(0.2) : kRedColor.withOpacity(0.2));

        final borderColor = backgroundColor;

        IconData iconData;
        Color iconColor;

        if (isAnswerEmpty) {
          iconData = Icons.remove_circle;
          iconColor = kLightGreyColor;
        } else if (answer.isCorrect!) {
          iconData = Icons.check_circle;
          iconColor = kGreenColor;
        } else {
          iconData = Icons.cancel;
          iconColor = kRedColor;
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 2),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(listQuestion.question.toString()),
                    const SizedBox(height: 4),
                    Text(
                      isAnswerEmpty ? 'Pertanyaan tidak terjawab' : answerChoice.toString(),
                      style: const TextStyle(fontWeight: semiBold),
                    ),
                  ],
                ),
              ),
              Icon(iconData, color: iconColor, size: 32),
            ],
          ),
        );
      }).toList(),
    );
  }
}