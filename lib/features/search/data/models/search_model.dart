class SearchResult {
  List<Articles>? articles;
  List<Courses>? courses;

  SearchResult({articles,courses});

  SearchResult.fromJson(Map<String, dynamic> json) {
    if (json['articles'] != null) {
      articles = <Articles>[];
      json['articles'].forEach((v) {
        articles!.add(Articles.fromJson(v));
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
    if (articles != null) {
      data['articles'] =articles!.map((v) => v.toJson()).toList();
    }
    if (courses != null) {
      data['courses'] =courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Articles {
  int? id;
  String? title;
  String? permalink;
  String? thumbnail;
  bool? hasVideo;

  Articles({
    this.id,
    this.title,
    this.permalink,
    this.thumbnail,
    this.hasVideo
  });

  Articles.fromJson(Map<String, dynamic> json) {
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