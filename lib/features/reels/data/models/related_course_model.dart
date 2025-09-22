class RelatedCourse {
  int? id;
  String? title;
  String? slug;
  String? url;
  String? image;
  String? timeCreated;
  String? skillLevel;

  RelatedCourse({
    this.id,
    this.title,
    this.slug,
    this.url,
    this.image,
    this.timeCreated,
    this.skillLevel
  });

  RelatedCourse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    url = json['url'];
    image = json['image'];
    timeCreated = json['time_created'];
    skillLevel = json['skill_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['url'] = url;
    data['image'] = image;
    data['time_created'] = timeCreated;
    data['skill_level'] = skillLevel;
    return data;
  }
}