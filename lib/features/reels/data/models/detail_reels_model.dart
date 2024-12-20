class DetailReels {
  String? title;
  String? fieldTags;
  String? created;
  String? fieldDisplayName;
  String? userPicture;
  String? fieldImage;
  String? videoUrl;
  int? id;

  DetailReels({
    this.title,
    this.fieldTags,
    this.created,
    this.fieldDisplayName,
    this.userPicture,
    this.fieldImage,
    this.videoUrl,
    this.id
  });

  DetailReels.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    fieldTags = json['field_tags'];
    created = json['created'];
    fieldDisplayName = json['field_display_name'];
    userPicture = json['user_picture'];
    fieldImage = json['field_image'];
    videoUrl = json['video_url'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['field_tags'] = fieldTags;
    data['created'] = created;
    data['field_display_name'] = fieldDisplayName;
    data['user_picture'] = userPicture;
    data['field_image'] = fieldImage;
    data['video_url'] = videoUrl;
    data['id'] = id;
    return data;
  }
}
