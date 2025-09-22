import 'package:data_learns_247/features/reels/data/models/related_contents_model.dart';
import 'package:data_learns_247/features/reels/data/models/related_course_model.dart';

class DetailReels {
  String? title;
  String? tag;
  String? slug;
  String? author;
  String? authorPhoto;
  String? dateCreated;
  String? videoUrl;
  String? videoDescription;
  RelatedCourse? relatedCourse;
  List<RelatedContents>? relatedContents;
  int? id;

  DetailReels({
    this.title,
    this.tag,
    this.slug,
    this.author,
    this.authorPhoto,
    this.dateCreated,
    this.videoUrl,
    this.videoDescription,
    this.relatedCourse,
    this.relatedContents,
    this.id
  });

  DetailReels.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    tag = json['tag'];
    slug = json['slug'];
    author = json['author'];
    authorPhoto = json['author_photo'];
    dateCreated = json['date_created'];
    videoUrl = json['video_url'];
    videoDescription = json['video_description'];
    relatedCourse = json['related_course'] != null
        ? RelatedCourse.fromJson(json['related_course'])
        : null;
    if (json['related_contents'] != null) {
      relatedContents = <RelatedContents>[];
      json['related_contents'].forEach((v) {
        relatedContents!.add(RelatedContents.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['tag'] = tag;
    data['slug'] = slug;
    data['author'] = author;
    data['author_photo'] = authorPhoto;
    data['date_created'] = dateCreated;
    data['video_url'] = videoUrl;
    data['video_description'] = videoDescription;
    if (relatedCourse != null) {
      data['related_course'] = relatedCourse!.toJson();
    }
    if (relatedContents != null) {
      data['related_contents'] =
          relatedContents!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}