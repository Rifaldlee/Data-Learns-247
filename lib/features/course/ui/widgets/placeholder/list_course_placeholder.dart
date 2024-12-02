import 'package:flutter/material.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class ListCoursePlaceholder extends StatelessWidget {
  const ListCoursePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            courseItemPlaceholder(),
            courseItemPlaceholder(),
            courseItemPlaceholder(),
            courseItemPlaceholder(),
            courseItemPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget courseItemPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RectangleShimmerSizedBox(height: 74, width: 94),
          SizedBox(width: 16),
          Expanded(
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
          )
        ],
      ),
    );
  }
}