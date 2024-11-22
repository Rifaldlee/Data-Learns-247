import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:data_learns_247/features/article/data/models/list_articles_model.dart';

class SimpleArticleItem extends StatelessWidget {
  final ListArticles listArticles;
  final Function() onTap;

  const SimpleArticleItem({super.key, required this.listArticles, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listArticles.blockGroup!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              unescape.convert(listArticles.title!),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              listArticles.dateCreated!,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}