import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:data_learns_247/features/article/data/models/list_link_model.dart';

class LinkArticleItem extends StatelessWidget {
  final ListLink listLink;
  final Function() onTap;

  const LinkArticleItem({super.key, required this.listLink, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: kWhiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  listLink.title!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: FastCachedImage(
                  url: listLink.image!,
                  height: 64,
                  width: 64,
                  fit: BoxFit.fill,
                  loadingBuilder: (context, progress) {
                    return const RectangleShimmerSizedBox(
                      height: 64,
                      width: 64
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}