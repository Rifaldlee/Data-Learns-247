class AnswersPayload {
  int? questionId;
  List<String>? answerId;

  AnswersPayload({this.questionId, this.answerId});

  AnswersPayload.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    answerId = json['answer_id'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['answer_id'] = answerId;
    return data;
  }
}