import 'package:flutter/material.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class SimpleArticleItemPlaceholder extends StatelessWidget {
  const SimpleArticleItemPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RectangleShimmerSizedBox(height: 24, width: 148),
          RectangleShimmerSizedBox(height: 48, width: double.infinity),
          RectangleShimmerSizedBox(height: 24, width: 148)
        ],
      ),
    );
  }
}