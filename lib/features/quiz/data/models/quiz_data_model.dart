import 'package:data_learns_247/features/quiz/data/models/quiz_questions_model.dart';

class QuizData {
  String? quizId;
  String? attemptId;
  int? attemptCount;
  int? timeLimit;
  String? title;
  List<QuizQuestions>? quizQuestions;

  QuizData({
    this.quizId,
    this.attemptId,
    this.attemptCount,
    this.timeLimit,
    this.title,
    this.quizQuestions
  });

  QuizData.fromJson(Map<String, dynamic> json) {
    quizId = json['quiz_id'];
    attemptId = json['attempt_id'];
    attemptCount = json['attempt_count'];
    timeLimit = json['time_limit'];
    title = json['title'];
    if (json['quiz_questions'] != null) {
      quizQuestions = <QuizQuestions>[];
      json['quiz_questions'].forEach((v) {
        quizQuestions!.add(QuizQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quiz_id'] = quizId;
    data['attempt_id'] = attemptId;
    data['attempt_count'] = attemptCount;
    data['time_limit'] = timeLimit;
    data['title'] = title;
    if (quizQuestions != null) {
      data['quiz_questions'] =
          quizQuestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}