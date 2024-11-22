class Course {
  bool? isEnrolled;
  String? title;
  String? fieldTags;
  String? created;
  String? fieldDisplayName;
  String? userPicture;
  String? fieldImage;
  List<String>? categories;
  String? progress;
  int? price;
  String? courseCode;
  String? courseType;
  String? duration;
  String? difficulty;
  String? courseFormat;
  List<Sections>? sections;
  String? body;
  int? id;

  Course({
    this.isEnrolled,
    this.title,
    this.fieldTags,
    this.created,
    this.fieldDisplayName,
    this.userPicture,
    this.fieldImage,
    this.categories,
    this.progress,
    this.price,
    this.courseCode,
    this.courseType,
    this.duration,
    this.difficulty,
    this.courseFormat,
    this.sections,
    this.body,
    this.id
  });

  Course.fromJson(Map<String, dynamic> json) {
    isEnrolled = json['is_enrolled'];
    title = json['title'];
    fieldTags = json['field_tags'];
    created = json['created'];
    fieldDisplayName = json['field_display_name'];
    userPicture = json['user_picture'];
    fieldImage = json['field_image'];
    categories = json['categories'].cast<String>();
    progress = json['progress'];
    price = json['price'] is int ? json['price'] : int.tryParse(json['price'] ?? '0');
    courseCode = json['course_code'];
    courseType = json['course_type'];
    duration = json['duration'];
    difficulty = json['difficulty'];
    courseFormat = json['course_format'];
    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(Sections.fromJson(v));
      });
    }
    body = json['body'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_enrolled'] = isEnrolled;
    data['title'] = title;
    data['field_tags'] = fieldTags;
    data['created'] = created;
    data['field_display_name'] = fieldDisplayName;
    data['user_picture'] = userPicture;
    data['field_image'] = fieldImage;
    data['categories'] = categories;
    data['progress'] = progress;
    data['price'] = price;
    data['course_code'] = courseCode;
    data['course_type'] = courseType;
    data['duration'] = duration;
    data['difficulty'] = difficulty;
    data['course_format'] = courseFormat;
    if (sections != null) {
      data['sections'] = sections!.map((v) => v.toJson()).toList();
    }
    data['body'] = body;
    data['id'] = id;
    return data;
  }
}

class Sections {
  int? sectionID;
  String? sectionTitle;
  List<Lessons>? lessons;

  Sections({this.sectionID, this.sectionTitle, this.lessons});

  Sections.fromJson(Map<String, dynamic> json) {
    sectionID = json['section_ID'];
    sectionTitle = json['section_title'];
    if (json['lessons'] != null) {
      lessons = <Lessons>[];
      json['lessons'].forEach((v) {
        lessons!.add(Lessons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['section_ID'] = sectionID;
    data['section_title'] = sectionTitle;
    if (lessons != null) {
      data['lessons'] = lessons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lessons {
  int? lessonID;
  String? lessonTitle;
  String? lessonType;
  bool? isComplete;

  Lessons({this.lessonID, this.lessonTitle, this.lessonType, this.isComplete});

  Lessons.fromJson(Map<String, dynamic> json) {
    lessonID = json['lesson_ID'];
    lessonTitle = json['lesson_title'];
    lessonType = json['lesson_type'];
    isComplete = json['is_complete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lesson_ID'] = lessonID;
    data['lesson_title'] = lessonTitle;
    data['lesson_type'] = lessonType;
    data['is_complete'] = isComplete;
    return data;
  }
}