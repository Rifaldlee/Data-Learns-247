import 'package:data_learns_247/features/quiz/data/models/answers_model.dart';

class ListQuestions {
  int? id;
  String? question;
  int? menuOrder;
  int? points;
  Answer? answer;

  ListQuestions({
    this.id,
    this.question,
    this.menuOrder,
    this.points,
    this.answer
  });

  ListQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    menuOrder = json['menu_order'];
    points = json['points'];
    answer = (json['answer'] != null && json['answer'] is Map<String, dynamic>)
        ? Answer.fromJson(json['answer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['menu_order'] = menuOrder;
    data['points'] = points;
    if (answer != null) {
      data['answer'] = answer!.toJson();
    }
    return data;
  }
}