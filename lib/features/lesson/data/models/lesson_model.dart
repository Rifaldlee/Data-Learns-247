class Lesson {
  String? title;
  int? previousLesson;
  int? nextLesson;
  String? lessonType;
  bool? isComplete;
  String? body;
  int? id;

  Lesson({
    this.title,
    this.previousLesson,
    this.nextLesson,
    this.lessonType,
    this.isComplete,
    this.body,
    this.id
  });

  Lesson.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    previousLesson = json['previous_lesson'];
    nextLesson = json['next_lesson'];
    lessonType = json['lesson_type'];
    isComplete = json['is_complete'];
    body = json['body'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['previous_lesson'] = previousLesson;
    data['next_lesson'] = nextLesson;
    data['lesson_type'] = lessonType;
    data['is_complete'] = isComplete;
    data['body'] = body;
    data['id'] = id;
    return data;
  }
}