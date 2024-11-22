import 'package:flutter/material.dart';
import 'package:data_learns_247/shared_ui/widgets/shimmer_sized_box.dart';

class LeadingArticlePlaceHolder extends StatelessWidget {
  const LeadingArticlePlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      padding: const EdgeInsets.only(bottom: 8),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RectangleShimmerSizedBox(height: 200, width: double.infinity),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RectangleShimmerSizedBox(height: 24, width: 148),
              RectangleShimmerSizedBox(height: 56, width: double.infinity),
              RectangleShimmerSizedBox(height: 24, width: 148)
            ],
          )
        ],
      ),
    );
  }
}