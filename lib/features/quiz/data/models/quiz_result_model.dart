class QuizResult {
  int? quizId;
  int? attemptId;
  int? grade;
  String? status;
  int? totalQuestions;
  int? answered;
  int? correctAnswers;
  int? wrongAnswers;
  String? duration;
  int? pointsEarned;
  int? possiblePoints;

  QuizResult({
    this.quizId,
    this.attemptId,
    this.grade,
    this.status,
    this.totalQuestions,
    this.answered,
    this.correctAnswers,
    this.wrongAnswers,
    this.duration,
    this.pointsEarned,
    this.possiblePoints
  });

  QuizResult.fromJson(Map<String, dynamic> json) {
    quizId = json['quiz_id'];
    attemptId = json['attempt_id'];
    grade = json['grade'];
    status = json['status'];
    totalQuestions = json['total_questions'];
    answered = json['answered'];
    correctAnswers = json['correct_answers'];
    wrongAnswers = json['wrong_answers'];
    duration = json['duration'];
    pointsEarned = json['points_earned'];
    possiblePoints = json['possible_points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quiz_id'] = quizId;
    data['attempt_id'] = attemptId;
    data['grade'] = grade;
    data['status'] = status;
    data['total_questions'] = totalQuestions;
    data['answered'] = answered;
    data['correct_answers'] = correctAnswers;
    data['wrong_answers'] = wrongAnswers;
    data['duration'] = duration;
    data['points_earned'] = pointsEarned;
    data['possible_points'] = possiblePoints;
    return data;
  }
}