class Choices {
  String? id;
  String? choice;
  bool? correct;
  String? marker;

  Choices({this.id, this.choice, this.correct, this.marker});

  Choices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    choice = json['choice'];
    correct = json['correct'];
    marker = json['marker'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['choice'] = choice;
    data['correct'] = correct;
    data['marker'] = marker;
    return data;
  }
}