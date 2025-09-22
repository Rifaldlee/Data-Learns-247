class Answer {
  String? id;
  String? choice;
  bool? isCorrect;
  String? marker;

  Answer({
    this.id,
    this.choice,
    this.isCorrect,
    this.marker
  });

  Answer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    choice = json['choice'];
    isCorrect = json['is_correct'];
    marker = json['marker'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['choice'] = choice;
    data['is_correct'] = isCorrect;
    data['marker'] = marker;
    return data;
  }
}