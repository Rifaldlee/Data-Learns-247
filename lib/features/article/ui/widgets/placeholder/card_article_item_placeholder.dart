import 'package:flutter/material.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class CardArticleItemPlaceholder extends StatelessWidget {
  const CardArticleItemPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: 260,
      margin: const EdgeInsets.only(right: 16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            ),
            child: RectangleShimmerSizedBox(height: 180, width: double.infinity),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RectangleShimmerSizedBox(height: 24, width: 148),
                  RectangleShimmerSizedBox(height: 48, width: double.infinity),
                  Spacer(),
                  RectangleShimmerSizedBox(height: 24, width: 148)
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}