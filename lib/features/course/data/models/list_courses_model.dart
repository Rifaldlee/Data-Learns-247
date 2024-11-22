class ListCourses {
  String? title;
  String? image;
  String? tag;
  String? author;
  String? authorPhoto;
  String? dateCreated;
  int? id;

  ListCourses({
    this.title,
    this.image,
    this.tag,
    this.author,
    this.authorPhoto,
    this.dateCreated,
    this.id
  });

  ListCourses.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    tag = json['tag'];
    author = json['author'];
    authorPhoto = json['author_photo'];
    dateCreated = json['date_created'];
    id = json['id'] is String ? int.tryParse(json['id']) : json['id'];
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
    return data;
  }
}
