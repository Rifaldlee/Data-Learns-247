class MyCoursesList {
  String? title;
  String? image;
  String? tag;
  String? author;
  String? authorPhoto;
  String? dateCreated;
  int? id;
  String? progress;

  MyCoursesList({
    this.title,
    this.image,
    this.tag,
    this.author,
    this.authorPhoto,
    this.dateCreated,
    this.id,
    this.progress
  });

  MyCoursesList.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    tag = json['tag'];
    author = json['author'];
    authorPhoto = json['author_photo'];
    dateCreated = json['date_created'];
    id = json['id'];
    progress = json['progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['image'] = image;
    data['tag'] = tag;
    data['author'] = author;
    data['author_photo'] = authorPhoto;
    data['date_created'] = dateCreated;
    data['id'] = id;
    data['progress'] = progress;
    return data;
  }
}