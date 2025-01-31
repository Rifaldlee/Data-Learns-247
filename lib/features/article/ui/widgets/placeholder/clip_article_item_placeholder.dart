import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';
import 'package:flutter/material.dart';

class ClipArticleItemPlaceholder extends StatelessWidget {
  const ClipArticleItemPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32),
          RectangleShimmerSizedBox(height: 24, width: 148),
          RectangleShimmerSizedBox(height: 48, width: double.infinity),
          SizedBox(height: 8),
          RectangleShimmerSizedBox(height: 200, width: double.infinity),
          SizedBox(height: 8),
          RectangleShimmerSizedBox(height: 24, width: 148),
        ],
      ),
    );
  }
}