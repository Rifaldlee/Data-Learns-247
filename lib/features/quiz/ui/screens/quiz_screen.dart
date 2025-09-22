import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:toastification/toastification.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/quiz/data/models/quiz_questions_model.dart';
import 'package:data_learns_247/features/quiz/cubit/end_quiz_cubit.dart';
import 'package:data_learns_247/features/quiz/cubit/quiz_logic_cubit.dart';
import 'package:data_learns_247/features/quiz/cubit/start_quiz_cubit.dart';
import 'package:data_learns_247/features/quiz/data/dto/answers_payload.dart';
import 'package:data_learns_247/features/quiz/data/dto/end_quiz_payload.dart';
import 'package:data_learns_247/shared_ui/widgets/affirmation_dialog.dart';
import 'package:data_learns_247/shared_ui/widgets/gradient_button.dart';

class QuizScreen extends StatefulWidget {
  final String lessonId;
  final String courseId;
  final String? chatbotId;

  const QuizScreen({
    super.key,
    required this.lessonId,
    required this.courseId,
    this.chatbotId
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Timer? _timer;
  int _totalSeconds = 0;
  int _remainingSeconds = 0;
  bool _isTimeUpSubmission = false;
  bool isSubmittingFromPopScope = false;
  StreamSubscription? _endQuizSubscription;

  @override
  void initState() {
    super.initState();
    final startQuizState = context.read<StartQuizCubit>().state;
    if (startQuizState is StartQuizCompleted) {
      final quizData = startQuizState.startQuizResponse.data!;
      context.read<QuizLogicCubit>().initializeQuiz(quizData);

      final timeLimitMinutes = quizData.timeLimit ?? 0;
      _remainingSeconds = timeLimitMinutes * 60;
      _totalSeconds = _remainingSeconds;

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds <= 0) {
          timer.cancel();
          if (!mounted) return;

          final quizState = context.read<QuizLogicCubit>().state;
          _isTimeUpSubmission = true;
          submitQuiz(context, quizState);

          final endQuizCubit = context.read<EndQuizCubit>();
          _endQuizSubscription = endQuizCubit.stream.listen((endState) {
            if (endState is EndQuizCompleted) {
              _endQuizSubscription?.cancel();
              if (!mounted) return;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AffirmationDialog(
                    message: 'Waktu habis! Jawaban akan otomatis terkirim',
                    cancelText: 'kembali',
                    proceedText: 'selesai',
                    onCancel: () {
                      Navigator.of(context).pop();
                      if (mounted) Navigator.pop(context);
                    },
                    onProceed: () {
                      Navigator.of(context).pop();
                      if (!mounted) return;
                      context.pushNamed(
                        RouteConstants.attemptDetail,
                        queryParameters: {
                          'attemptId': endState.endQuizResponse.data!.attemptId.toString(),
                          'lessonId': widget.lessonId,
                          'courseId': widget.courseId,
                          'chatbotId': widget.chatbotId ?? ''
                        },
                      );
                      context.read<QuizLogicCubit>().clearQuiz();
                    },
                  ),
                );
              });
            }
          });
        } else {
          if (mounted) {
            setState(() {
              _remainingSeconds--;
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _endQuizSubscription?.cancel();
    super.dispose();
  }

  bool showSubmitQuizButton(QuizLogicState state) {
    final totalQuestions = state.quizData.quizQuestions?.length ?? 0;
    final allAnswered = state.userAnswers.length == totalQuestions;
    final isLastQuestion = state.currentIndex == totalQuestions - 1;

    if (!isLastQuestion && !allAnswered) return false;
    return true;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void submitQuiz(BuildContext context, QuizLogicState state) {
    final startQuizState = context.read<StartQuizCubit>().state;
    if (startQuizState is! StartQuizCompleted) return;

    final attemptId = startQuizState.startQuizResponse.data!.attemptId!;
    final quizId = startQuizState.startQuizResponse.data!.quizId;

    final answers = state.userAnswers.entries.map((entry) {
      return AnswersPayload(
        questionId: entry.key,
        answerId: entry.value,
      );
    }).toList();

    final payload = EndQuizPayload(
      attemptId: attemptId.toInt(),
      quizId: quizId.toInt(),
      answers: answers,
    );
    _timer?.cancel();

    context.read<EndQuizCubit>().endQuiz(payload);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EndQuizCubit, EndQuizState>(
      listener: (context, endState) {
        if (endState is EndQuizCompleted && isSubmittingFromPopScope) {
          context.pushNamed(
            RouteConstants.attemptDetail,
            queryParameters: {
              'attemptId': endState.endQuizResponse.data!.attemptId.toString(),
              'lessonId': widget.lessonId.toString(),
              'courseId': widget.courseId.toString(),
              'chatbotId': widget.chatbotId.toString()
            },
          );
          context.read<QuizLogicCubit>().clearQuiz();
        }
      },
      child: BlocBuilder<QuizLogicCubit, QuizLogicState>(
        builder: (context, state) {
          if (state.quizData.quizQuestions != null &&
              state.quizData.quizQuestions!.isNotEmpty) {
            final question = state.quizData.quizQuestions![state.currentIndex];

            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) {
                  showDialog(
                    context: context,
                    builder: (context) => AffirmationDialog(
                      message: 'Quiz otomatis berakhir, apakah anda yakin?',
                      onProceed: () {
                        Navigator.of(context).pop();
                        isSubmittingFromPopScope = true;
                        submitQuiz(context, state);
                      },
                    ),
                  );
                }
              },
              child: Scaffold(
                backgroundColor: kWhiteColor,
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      LinearPercentIndicator(
                        lineHeight: 12,
                        barRadius: const Radius.circular(12),
                        progressColor: _remainingSeconds <= 30 ? Colors.red : kBlueColor,
                        percent: _totalSeconds == 0 ? 0 : _remainingSeconds / _totalSeconds,
                        trailing: Text(
                          _formatDuration(Duration(seconds: _remainingSeconds)),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.question ?? 'Pertanyaan tidak ditemukan',
                        style: Theme.of(context).textTheme.headlineMedium!,
                      ),
                      const SizedBox(height: 8),
                      questionChoices(question, state),
                      const Spacer(),
                      questionNavigationButton(state),
                      const SizedBox(height: 16),
                      questionButton(state),
                      const SizedBox(height: 16),
                      if (showSubmitQuizButton(state))
                        submitQuizButton(context, state),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget submitQuizButton(BuildContext context, QuizLogicState quizState) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BlocConsumer<EndQuizCubit, EndQuizState>(
        builder: (context, endState) {
          if (endState is EndQuizLoading) {
            return Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                    colors: [kBlueColor, kGreenColor]
                ),
              ),
              child: const Center(
                heightFactor: 42,
                widthFactor: 42,
                child:  CircularProgressIndicator(
                  color: kWhiteColor,
                  backgroundColor: kWhiteColor,
                ),
              ),
            );
          }
          return GradientButton(
            buttonTitle: 'Selesaikan kuis',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AffirmationDialog(
                  message: 'Anda yakin menyelesaikan kuis sekarang?',
                  onProceed: () {
                    Navigator.of(context).pop();
                    submitQuiz(context, quizState);
                  },
                ),
              );
            },
          );
        },
        listener: (context, endState) {
          if (endState is EndQuizCompleted) {
            if (_isTimeUpSubmission) {
              _isTimeUpSubmission = false;
            } else {
              context.pushNamed(
                RouteConstants.attemptDetail,
                queryParameters: {
                  'attemptId': endState.endQuizResponse.data!.attemptId.toString(),
                  'lessonId': widget.lessonId.toString(),
                  'courseId': widget.courseId.toString(),
                  'chatbotId': widget.chatbotId.toString()
                },
              );
              context.read<QuizLogicCubit>().clearQuiz();
            }
          } else if (endState is EndQuizError) {
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
              title: const Text('Gagal mengirim kuis'),
              description: RichText(text: TextSpan(text: endState.message)),
              icon: const Icon(Icons.cancel_outlined),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              borderRadius: BorderRadius.circular(12),
            );
          }
        },
      ),
    );
  }

  Widget questionChoices(QuizQuestions question, QuizLogicState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        question.choices!.length,
            (index) {
          final choice = question.choices![index];
          final isSelected = state.selectedAnswers[question.id] == choice.id;

          return GestureDetector(
            onTap: () {
              context.read<QuizLogicCubit>().selectAnswer(question.id!, choice.id!);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? kGreenColor.withOpacity(0.2) : kWhiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? kGreenColor : Colors.grey.withOpacity(0.2),
                  width: 2
                )
              ),
              child: Text("${choice.marker}. ${choice.choice}"),
            ),
          );
        },
      ),
    );
  }

  Widget questionNavigationButton(QuizLogicState state) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextButton(
            onPressed: state.currentIndex > 0
              ? () => context.read<QuizLogicCubit>().goToPrevious()
              : null,
            style: TextButton.styleFrom(
              backgroundColor: state.currentIndex > 0 ? kBlueColor : kLightGreyColor,
              fixedSize: const Size(
                double.infinity,
                48
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
            ),
            child: Text(
              "Soal Sebelumnya",
              style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: kWhiteColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: TextButton(
            onPressed: state.currentIndex < state.quizData.quizQuestions!.length - 1
              ? () => context.read<QuizLogicCubit>().goToNext()
              : null,
            style: TextButton.styleFrom(
              backgroundColor: state.currentIndex < state.quizData.quizQuestions!.length - 1
                ? kGreenColor : kLightGreyColor,
              fixedSize: const Size(
                double.infinity,
                48
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
            ),
            child: Text(
              "Soal Berikutnya",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: kWhiteColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget questionButton(QuizLogicState state) {
    return Wrap(
      spacing: 8,
      children: List.generate(
        state.quizData.quizQuestions!.length, (index) {
          final question = state.quizData.quizQuestions![index];
          final questionId = question.id!;
          final isCurrent = index == state.currentIndex;
          final isAnswered = state.selectedAnswers.containsKey(questionId);

          Color backgroundColor;
          Color textColor;

          if (isCurrent) {
            backgroundColor = kBlueColor;
            textColor = kWhiteColor;
          } else if (isAnswered) {
            backgroundColor = kGreenColor;
            textColor = kWhiteColor;
          } else {
            backgroundColor = Colors.grey[300]!;
            textColor = Colors.grey[700]!;
          }

          return TextButton(
            onPressed: () => context.read<QuizLogicCubit>().jumpTo(index),
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor,
              fixedSize: const Size(32, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(color: textColor),
            ),
          );
        },
      ),
    );
  }

}