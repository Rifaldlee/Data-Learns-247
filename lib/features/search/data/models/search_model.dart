class SearchResult {
  List<Contents>? contents;
  List<Courses>? courses;

  SearchResult({contents,courses});

  SearchResult.fromJson(Map<String, dynamic> json) {
    if (json['contents'] != null) {
      contents = <Contents>[];
      json['contents'].forEach((v) {
        contents!.add(Contents.fromJson(v));
      });
    }
    if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses!.add(Courses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contents != null) {
      data['contents'] =contents!.map((v) => v.toJson()).toList();
    }
    if (courses != null) {
      data['courses'] =courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contents {
  int? id;
  String? title;
  String? permalink;
  String? thumbnail;
  bool? hasVideo;

  Contents({
    this.id,
    this.title,
    this.permalink,
    this.thumbnail,
    this.hasVideo
  });

  Contents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    permalink = json['permalink'];
    thumbnail = json['thumbnail'];
    hasVideo = json['has_video'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] =title;
    data['permalink'] =permalink;
    data['thumbnail'] =thumbnail;
    data['has_video'] = hasVideo;
    return data;
  }
}

class Courses {
  int? id;
  String? title;
  String? permalink;
  String? thumbnail;

  Courses({
    this.id,
    this.title,
    this.permalink,
    this.thumbnail
  });

  Courses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    permalink = json['permalink'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] =title;
    data['permalink'] =permalink;
    data['thumbnail'] =thumbnail;
    return data;
  }
}