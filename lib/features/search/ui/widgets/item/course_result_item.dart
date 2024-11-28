import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/search/data/models/search_model.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class CourseResultItem extends StatelessWidget {
  final Courses courses;
  final Function() onTap;
  const CourseResultItem({super.key, required this.courses, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: FastCachedImage(
                  url: courses.thumbnail!,
                  height: 74,
                  width: 94,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(seconds: 0),
                  loadingBuilder: (context, progress) {
                    return const RectangleShimmerSizedBox(
                      height: 74,
                      width: 94,
                    );
                  }
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unescape.convert(courses.title ?? "No Title"),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: kBlueColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Course',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}