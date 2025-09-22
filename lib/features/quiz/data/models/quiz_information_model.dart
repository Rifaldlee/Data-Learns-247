import 'package:data_learns_247/features/quiz/data/models/list_attempts_model.dart';

class QuizInformation {
  int? id;
  String? title;
  int? passingPercent;
  int? timeLimit;
  int? totalQuestions;
  int? allowedAttempts;
  int? totalAttempts;
  List<ListAttempts>? listAttempt;

  QuizInformation({
    this.id,
    this.title,
    this.passingPercent,
    this.timeLimit,
    this.totalQuestions,
    this.allowedAttempts,
    this.totalAttempts,
    this.listAttempt
  });

  QuizInformation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    passingPercent = json['passing_percent'];
    timeLimit = json['time_limit'];
    totalQuestions = json['total_questions'];
    allowedAttempts = json['allowed_attempts'];
    totalAttempts = json['total_attempts'];
    if (json['list_attempts'] != null) {
      listAttempt = <ListAttempts>[];
      json['list_attempts'].forEach((v) {
        listAttempt!.add(ListAttempts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['passing_percent'] = passingPercent;
    data['time_limit'] = timeLimit;
    data['total_questions'] = totalQuestions;
    data['allowed_attempts'] = allowedAttempts;
    data['total_attempts'] = totalAttempts;
    if (listAttempt != null) {
      data['list_attempts'] =
        listAttempt!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}