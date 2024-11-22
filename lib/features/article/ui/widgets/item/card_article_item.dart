import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:shimmer/shimmer.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/article/data/models/list_articles_model.dart';

class CardArticleItem extends StatelessWidget {
  final ListArticles listArticles;
  final Function() onTap;

  const CardArticleItem({super.key, required this.listArticles, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 320,
        width: 260,
        margin: const EdgeInsets.only(right: 16.0),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 2,
              style: BorderStyle.solid,
            ),
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 2,
              style: BorderStyle.solid,
            ),
            right: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 2,
              style: BorderStyle.solid,
            ),
            top: BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: FastCachedImage(
                url: listArticles.image!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(seconds: 0),
                loadingBuilder: (context, progress) {
                  return SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Shimmer.fromColors(
                      baseColor: kShimmerBaseColor,
                      highlightColor: kShimmerHighligtColor,
                      child: const Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      listArticles.dateCreated!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}