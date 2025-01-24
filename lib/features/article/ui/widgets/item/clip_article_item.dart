import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/article/data/models/random_article_model.dart';
import 'package:shimmer/shimmer.dart';

class ClipArticleItem extends StatelessWidget {
  final RandomArticle randomArticle;
  final Function() onTap;

  const ClipArticleItem({super.key, required this.randomArticle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  randomArticle.blockGroup,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  unescape.convert(randomArticle.title),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSerifText(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FastCachedImage(
                  url: randomArticle.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(seconds: 0),
                    loadingBuilder: (context, progress) {
                      return const RectangleShimmerSizedBox(
                        height: 200,
                        width: double.infinity
                      );
                    }
                ),
                const SizedBox(height: 16),
                Text(
                  randomArticle.dateCreated,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -10,
          left: 50,
          child: Transform.rotate(
            angle: 30 * (3.1416 / 180), // Convert degrees to radians
            child: Image.asset(
              "assets/img/img_clip.png",
              width: 64,
              height: 64,
            ),
          ),
        ),
      ],
    );
  }
}