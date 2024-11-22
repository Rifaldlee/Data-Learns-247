class ListLink {
  int? id;
  String? title;
  bool? hasVideo;
  String? image;

  ListLink({this.id, this.title, this.hasVideo, this.image});

  ListLink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    hasVideo = json['has_video'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['has_video'] = hasVideo;
    data['image'] = image;
    return data;
  }
}