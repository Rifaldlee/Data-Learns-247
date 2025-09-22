import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';
import 'package:flutter/material.dart';

class QuizInformationPlaceholder extends StatelessWidget {
  const QuizInformationPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 16
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                RectangleShimmerSizedBox(
                  height: 48,
                  width: double.infinity
                ),
                SizedBox(height: 12),
                RectangleShimmerSizedBox(
                  height: 186,
                  width: double.infinity
                ),
                SizedBox(height: 4),
                RectangleShimmerSizedBox(
                  height: 48,
                  width: double.infinity
                ),
              ],
            ),
          ),
          RectangleShimmerSizedBox(
            height: 64,
            width: double.infinity
          ),
        ],
      ),
    );
  }
}