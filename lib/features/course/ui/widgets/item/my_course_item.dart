import 'package:data_learns_247/features/course/data/models/my_courses_list_model.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyCourseItem extends StatelessWidget {
  final MyCoursesList myCoursesList;
  final Function() onTap;
  const MyCourseItem({super.key, required this.myCoursesList, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FastCachedImage(
                  url: myCoursesList.image!,
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unescape.convert(myCoursesList.title!),
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
                                    url: myCoursesList.authorPhoto!,
                                    fadeInDuration: const Duration(seconds: 0),
                                  )
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                myCoursesList.author!,
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
                            myCoursesList.dateCreated!,
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
                    CircularPercentIndicator(
                      radius: 30,
                      lineWidth: 4,
                      percent: myCoursesList.progress!.toDouble() / 100,
                      progressColor: kGreenColor,
                      center: Text(
                        '${myCoursesList.progress}%',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500
                        )
                      ),
                    )
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