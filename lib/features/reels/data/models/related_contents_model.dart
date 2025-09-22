class RelatedContents {
  int? id;
  String? title;
  String? slug;
  String? url;
  String? image;
  String? timeAgo;
  String? author;
  String? authorAvatar;
  String? category;

  RelatedContents({
    this.id,
    this.title,
    this.slug,
    this.url,
    this.image,
    this.timeAgo,
    this.author,
    this.authorAvatar,
    this.category
  });

  RelatedContents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    url = json['url'];
    image = json['image'];
    timeAgo = json['time_ago'];
    author = json['author'];
    authorAvatar = json['author_avatar'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['url'] = url;
    data['image'] = image;
    data['time_ago'] = timeAgo;
    data['author'] = author;
    data['author_avatar'] = authorAvatar;
    data['category'] = category;
    return data;
  }
}