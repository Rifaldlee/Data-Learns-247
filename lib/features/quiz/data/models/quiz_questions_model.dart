import 'package:data_learns_247/features/quiz/data/models/choices_model.dart';

class QuizQuestions {
  int? id;
  String? question;
  int? menuOrder;
  int? points;
  List<Choices>? choices;

  QuizQuestions({
    this.id,
    this.question,
    this.menuOrder,
    this.points,
    this.choices
  });

  QuizQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    menuOrder = json['menu_order'];
    points = json['points'];
    if (json['choices'] != null) {
      choices = <Choices>[];
      json['choices'].forEach((v) {
        choices!.add(Choices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['menu_order'] = menuOrder;
    data['points'] = points;
    if (choices != null) {
      data['choices'] = choices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}