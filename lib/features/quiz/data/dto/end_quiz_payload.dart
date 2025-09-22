import 'package:data_learns_247/features/quiz/data/dto/answers_payload.dart';

class EndQuizPayload {
  int? attemptId;
  int? quizId;
  List<AnswersPayload>? answers;

  EndQuizPayload({this.attemptId, this.quizId, this.answers});

  EndQuizPayload.fromJson(Map<String, dynamic> json) {
    attemptId = json['attempt_id'];
    quizId = json['quiz_id'];
    if (json['answers'] != null) {
      answers = <AnswersPayload>[];
      json['answers'].forEach((v) {
        answers!.add(AnswersPayload.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attempt_id'] = attemptId;
    data['quiz_id'] = quizId;
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}