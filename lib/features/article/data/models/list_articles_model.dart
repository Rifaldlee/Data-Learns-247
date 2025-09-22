class ListArticles {
  String? blockGroup;
  String? title;
  String? image;
  String? tag;
  String? author;
  String? authorPhoto;
  String? dateCreated;
  String? category;
  int? id;
  bool? hasVideo;

  ListArticles({
    this.blockGroup,
    this.title,
    this.image,
    this.tag,
    this.author,
    this.authorPhoto,
    this.dateCreated,
    this.category,
    this.id,
    this.hasVideo
  });

  ListArticles.fromJson(Map<String, dynamic> json) {
    blockGroup = json['block-group'];
    title = json['title'];
    image = json['image'];
    tag = json['tag'];
    author = json['author'];
    authorPhoto = json['author_photo'];
    dateCreated = json['date_created'];
    category = json['category'];
    id = json['id'];
    hasVideo = json['has_video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['block-group'] = blockGroup;
    data['title'] = title;
    data['image'] = image;
    data['tag'] = tag;
    data['author'] = author;
    data['author_photo'] = authorPhoto;
    data['date_created'] = dateCreated;
    data['category'] = category;
    data['id'] = id;
    data['has_video'] = hasVideo;
    return data;
  }
}
