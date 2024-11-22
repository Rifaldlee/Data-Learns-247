import 'package:flutter/material.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class DetailCoursePlaceholder extends StatelessWidget {
  const DetailCoursePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        leading: Transform.translate(
            offset: const Offset(16.0, 0.0),
            child: const RectangleShimmerSizedBox(height: 32, width: 32)
        ),
      ),
      body: const Padding(
        padding: EdgeInsetsDirectional.symmetric(
          vertical: 12.0,
          horizontal: 32.0,
        ),
        child: Column(
          children: [
            RectangleShimmerSizedBox(height: 200, width: double.infinity),
            SizedBox(height: 8),
            RectangleShimmerSizedBox(height: 22, width: double.infinity),
            SizedBox(height: 12),
            RectangleShimmerSizedBox(height: 42, width: double.infinity),
            SizedBox(height: 12),
            Row(
              children: [
                CircularShimmerSizedBox(height: 48, width: 48),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RectangleShimmerSizedBox(height: 24, width: double.infinity),
                      SizedBox(height: 8),
                      RectangleShimmerSizedBox(height: 24, width: double.infinity),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            RectangleShimmerSizedBox(height: 200, width: double.infinity),
            RectangleShimmerSizedBox(height: 24, width: double.infinity),
            RectangleShimmerSizedBox(height: 24, width: double.infinity),
            RectangleShimmerSizedBox(height: 56, width: double.infinity),
          ],
        ),
      ),
    );
  }
}