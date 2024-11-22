import 'package:data_learns_247/features/article/data/models/list_link_model.dart';

class Article {
  String? title;
  String? fieldTags;
  String? created;
  String? fieldDisplayName;
  String? userPicture;
  String? fieldImage;
  String? body;
  int? id;
  List<ListLink>? listLink;

  Article({
    this.title,
    this.fieldTags,
    this.created,
    this.fieldDisplayName,
    this.userPicture,
    this.fieldImage,
    this.body,
    this.id,
    this.listLink
  });

  Article.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    fieldTags = json['field_tags'];
    created = json['created'];
    fieldDisplayName = json['field_display_name'];
    userPicture = json['user_picture'];
    fieldImage = json['field_image'];
    body = json['body'];
    id = json['id'];
    if (json['list_link'] != null) {
      listLink = <ListLink>[];
      json['list_link'].forEach((v) {
        listLink!.add(ListLink.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['field_tags'] = fieldTags;
    data['created'] = created;
    data['field_display_name'] = fieldDisplayName;
    data['user_picture'] = userPicture;
    data['field_image'] = fieldImage;
    data['body'] = body;
    data['id'] = id;
    if (listLink != null) {
      data['list_link'] = listLink!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
