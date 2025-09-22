import 'package:data_learns_247/features/quiz/data/models/list_questions_model.dart';

class Attempt {
  String? quizId;
  int? attemptId;
  String? attemptCount;
  String? title;
  int? totalQuestions;
  int? answered;
  int? correct;
  int? wrong;
  int? unanswered;
  String? startDate;
  String? startTime;
  String? duration;
  String? grade;
  String? status;
  List<ListQuestions>? listQuestions;

  Attempt({
    this.quizId,
    this.attemptId,
    this.attemptCount,
    this.title,
    this.totalQuestions,
    this.answered,
    this.correct,
    this.wrong,
    this.unanswered,
    this.startDate,
    this.startTime,
    this.duration,
    this.grade,
    this.status,
    this.listQuestions
  });

  Attempt.fromJson(Map<String, dynamic> json) {
    quizId = json['quiz_id'];
    attemptId = json['attempt_id'];
    attemptCount = json['attempt_count'];
    title = json['title'];
    totalQuestions = json['total_questions'];
    answered = json['answered'];
    correct = json['correct'];
    wrong = json['wrong'];
    unanswered = json['unanswered'];
    startDate = json['start_date'];
    startTime = json['start_time'];
    duration = json['duration'];
    grade = json['grade'];
    status = json['status'];
    if (json['list_questions'] != null) {
      listQuestions = <ListQuestions>[];
      json['list_questions'].forEach((v) {
        listQuestions!.add(ListQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quiz_id'] = quizId;
    data['attempt_id'] = attemptId;
    data['attempt_count'] = attemptCount;
    data['title'] = title;
    data['total_questions'] = totalQuestions;
    data['answered'] = answered;
    data['correct'] = correct;
    data['wrong'] = wrong;
    data['unanswered'] = unanswered;
    data['start_date'] = startDate;
    data['start_time'] = startTime;
    data['duration'] = duration;
    data['grade'] = grade;
    data['status'] = status;
    if (listQuestions != null) {
      data['list_questions'] =
          listQuestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}