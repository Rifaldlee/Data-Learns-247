import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/course/data/models/list_courses_model.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class CourseItem extends StatelessWidget {
  final ListCourses listCourses;
  final Function() onTap;

  const CourseItem({super.key, required this.listCourses, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FastCachedImage(
                  url: listCourses.image!,
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listCourses.title!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(12),
                            child: FastCachedImage(
                              url: listCourses.authorPhoto!,
                              fadeInDuration: const Duration(seconds: 0),
                            )
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          listCourses.author!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              color: kLightGreyColor
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Text(
                      listCourses.dateCreated!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          color: kLightGreyColor
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}