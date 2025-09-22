class ListAttempts {
  int? id;
  int? attempt;
  String? grade;
  String? status;

  ListAttempts({this.id, this.attempt, this.grade, this.status});

  ListAttempts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attempt = json['attempt'];
    grade = json['grade'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['attempt'] = attempt;
    data['grade'] = grade;
    data['status'] = status;
    return data;
  }
}