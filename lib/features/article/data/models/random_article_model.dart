class RandomArticle {
  final String blockGroup;
  final String title;
  final String image;
  final String tag;
  final String author;
  final String authorPhoto;
  final String dateCreated;
  String? category;
  final String id;
  final bool? hasVideo;

  RandomArticle({
    required this.blockGroup,
    required this.title,
    required this.image,
    required this.tag,
    required this.author,
    required this.authorPhoto,
    required this.dateCreated,
    required this.category,
    required this.id,
    required this.hasVideo
  });
}