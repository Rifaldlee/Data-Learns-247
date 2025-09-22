import 'package:data_learns_247/features/article/data/models/detail_article_model.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class ContentArticleHeading extends StatelessWidget {
  final Article article;

  const ContentArticleHeading({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final titleDoc = parse(article.title!);
    var title = titleDoc.querySelector('a')?.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        articleImage(article.fieldImage!),
        const SizedBox(height: 16),
        articleTitle(title ?? 'No Title'),
        const SizedBox(height: 12),
        articleAuthorInfo(article.fieldDisplayName ?? 'Unknown', article.created ?? '', article.userPicture!),
      ],
    );
  }

  Widget articleImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FastCachedImage(
          url: imageUrl,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, progress) {
            return const RectangleShimmerSizedBox(
                height: 200,
                width: double.infinity
            );
          }
      ),
    );
  }

  Widget articleTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget articleAuthorInfo(String authorName, String date, String photoUrl) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(photoUrl),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              authorName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}