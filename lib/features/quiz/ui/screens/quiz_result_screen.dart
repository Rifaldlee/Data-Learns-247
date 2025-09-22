import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/quiz/data/models/quiz_result_model.dart';
import 'package:data_learns_247/shared_ui/widgets/custom_app_bar.dart';

class QuizResultScreen extends StatefulWidget {
  final QuizResult quizResult;

  const QuizResultScreen({super.key, required this.quizResult});

  @override
  State<QuizResultScreen> createState() => _QuizResultState();
}

class _QuizResultState extends State<QuizResultScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kWhiteColor,
        statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        appBar: const CustomAppBar(
          showBackButton: true,
        ),
        backgroundColor: kWhiteColor,
        body: Column(
          children: [
            Text(widget.quizResult.grade.toString()),
            Text(widget.quizResult.status.toString())
          ],
        ),
      ),
    );
  }
}