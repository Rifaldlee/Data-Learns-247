import 'package:data_learns_247/features/authentication/data/models/user/avatar_urls.dart';
import 'package:data_learns_247/features/authentication/data/models/user/links.dart';
import 'package:data_learns_247/features/authentication/data/models/user/meta.dart';

class User {
  int? id;
  String? name;
  String? url;
  String? description;
  String? link;
  String? slug;
  AvatarUrls? avatarUrls;
  Meta? meta;
  Links? links;

  User({
    this.id,
    this.name,
    this.url,
    this.description,
    this.link,
    this.slug,
    this.avatarUrls,
    this.meta,
    this.links,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    description = json['description'];
    link = json['link'];
    slug = json['slug'];
    avatarUrls = json['avatar_urls'] != null ? AvatarUrls.fromJson(json['avatar_urls']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    links = json['_links'] != null ? Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;

    data['url'] = url;
    data['description'] = description;
    data['link'] = link;
    data['slug'] = slug;
    if (avatarUrls != null) {
      data['avatar_urls'] = avatarUrls!.toJson();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (links != null) {
      data['_links'] = links!.toJson();
    }
    return data;
  }
}