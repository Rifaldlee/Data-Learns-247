import 'package:data_learns_247/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class MyCourseListPlaceHolder extends StatelessWidget {
  const MyCourseListPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            myCourseItemPlaceholder(),
            myCourseItemPlaceholder(),
            myCourseItemPlaceholder(),
            myCourseItemPlaceholder(),
            myCourseItemPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget myCourseItemPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RectangleShimmerSizedBox(height: 74, width: 94),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RectangleShimmerSizedBox(height: 32, width: double.infinity),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          CircularShimmerSizedBox(height: 32, width: 32),
                          SizedBox(width: 4),
                          Expanded(
                            child: RectangleShimmerSizedBox(height: 24, width: double.infinity),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      RectangleShimmerSizedBox(height: 24, width: double.infinity),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: kWhiteColor,
                    shape: BoxShape.circle
                  ),
                  child: const CircularShimmerSizedBox(height: 64, width: 64)
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}