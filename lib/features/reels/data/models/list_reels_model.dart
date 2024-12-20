class ListReels {
  String? title;
  String? tag;
  String? author;
  String? authorPhoto;
  String? dateCreated;
  String? videoUrl;
  int? id;

  ListReels({
    this.title,
    this.tag,
    this.author,
    this.authorPhoto,
    this.dateCreated,
    this.videoUrl,
    this.id
  });

  ListReels.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    tag = json['tag'];
    author = json['author'];
    authorPhoto = json['author_photo'];
    dateCreated = json['date_created'];
    videoUrl = json['video_url'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['tag'] = tag;
    data['author'] = author;
    data['author_photo'] = authorPhoto;
    data['date_created'] = dateCreated;
    data['video_url'] = videoUrl;
    data['id'] = id;
    return data;
  }
}